# frozen_string_literal: true

require 'json'
require 'uri'
require 'net/http'

module Plugin::MiqHub
  # OAuth tokenを渡してGitHubのAPIを叩くクラス
  # 関数名に!が付いているのは同期的であることを示す
  class API
    ENDPOINT = URI.parse 'https://api.github.com/graphql'

    OWNER = <<~GRAPHQL
      login
      url
      avatarUrl
      repositories {
        totalCount
      }
    GRAPHQL

    REPO = <<~GRAPHQL
      name
      nameWithOwner
      owner {
        #{OWNER}
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
    GRAPHQL

    QUERY_ME = <<~GRAPHQL
      query {
        viewer {
          #{OWNER}
        }
      }
    GRAPHQL

    QUERY_REPOS = <<~GRAPHQL
      query {
        search(query: "topic:mikutter-plugin", type: REPOSITORY, first: 100) {
          nodes {
            ... on Repository {
              #{REPO}
            }
          }
        }
      }
    GRAPHQL

    QUERY_REPO = <<~GRAPHQL
      query($owner: String!, $name: String!) {
        repository(owner: $owner, name: $name) {
          #{REPO}
        }
      }
    GRAPHQL

    QUERY_OWNER = <<~GRAPHQL
      query($name: String!) {
        repositoryOwner(login: $name) {
          #{OWNER}
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
        it['errors'] and return Deferred.fail it['errors'].first['message']
        it['data']['search']['nodes'].map(&PM.method(:parse_repo))
      end
    end

    def fetch_repo(owner, name)
      Deferred.next do
        it = +(fetch QUERY_REPO, owner: owner, name: name)
        it['errors'] and return Deferred.fail it['errors'].first['message']
        PM.parse_repo it['data']['repository']
      end
    end

    def fetch_owner(name)
      Deferred.next do
        it = +(fetch QUERY_OWNER, name: name)
        it['errors'] and return Deferred.fail it['errors'].first['message']
        PM.parse_owner it['data']['repositoryOwner']
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

  end

module_function

  def parse_repo(it)
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

  def parse_owner(it)
    Owner.new(
      idname: it['login'],
      url: it['url'],
      avatar_url: it['avatarUrl'],
      repo_count: it['repositories']['totalCount'],
    )
  end
end
