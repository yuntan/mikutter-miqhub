# frozen_string_literal: true

require 'json'
require 'uri'
require 'net/http'

module Plugin::MiqHub
  # OAuth tokenを渡してGitHubのAPIを叩くクラス
  # 関数名に!が付いているのは同期的であることを示す
  class API
    ENDPOINT = URI.parse 'https://api.github.com/graphql'

    QUERY_ME = <<~GRAPHQL
      query {
        viewer {
          login
          url
          avatarUrl
          repositories {
            totalCount
          }
        }
      }
    GRAPHQL

    QUERY_REPOS = <<~GRAPHQL
      query {
        search(query: "topic:mikutter-plugin", type: REPOSITORY, first: 100) {
          nodes {
            ... on Repository {
              name
              nameWithOwner
              owner {
                login
                url
                avatarUrl
                repositories {
                  totalCount
                }
              }
              description
              stargazers {
                totalCount
              }
              viewerHasStarred
              forkCount
              createdAt
              updatedAt
              url
              defaultBranchRef {
                name
              }
            }
          }
        }
      }
    GRAPHQL

    def initialize(token)
      @token = token
    end

    def header
      @header ||= {
        'Authorization' => "bearer #{@token}",
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
      }.freeze
    end

    def fetch_me!
      it = fetch! QUERY_ME
      parse_owner it['data']['viewer']
    end

    def fetch_repos
      Deferred.next do
        it = +(fetch QUERY_REPOS)
        it['data']['search']['nodes'].map do |it|
          Repository.new(
            name: it['name'],
            name_with_owner: it['nameWithOwner'],
            owner: (parse_owner it['owner']),
            description: it['description'] || '',
            star_count: it['stargazers']['totalCount'],
            starred?: it['viewerHasStarred'],
            fork_count: it['forkCount'],
            created: it['createdAt'],
            modified: it['updatedAt'],
            url: it['url'],
            default_branch_name: it['defaultBranchRef']['name'],
          )
        end
      end
    end

  private

    def fetch(query, **data)
      Deferred.new { fetch! query, data }
    end

    def fetch!(query, **data)
      body = nil
      (Net::HTTP.new ENDPOINT.host, ENDPOINT.port).tap do |http|
        http.use_ssl = true
      end.start do |http|
        req = Net::HTTP::Post.new ENDPOINT.path, header
        req.body = { query: query, variables: data }.to_json
        http.request req do |res|
          res.code == '200' or next Deferred.fail res.message
          body = res.body
        end
      end

      JSON.parse body
    end

    def parse_owner(owner)
      Owner.new(
        idname: owner['login'],
        url: owner['url'],
        avatar_url: owner['avatarUrl'],
        repo_count: owner['repositories']['totalCount'],
      )
    end
  end
end
