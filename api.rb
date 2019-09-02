# frozen_string_literal: true

require 'json'
require 'uri'
require 'net/http'

require_relative 'model/repository'
require_relative 'model/owner'

module Plugin::MiqHub
  ENDPOINT = URI.parse 'https://api.github.com/graphql'

  HEADER = {
    'Authorization' => 'bearer c291fd91e9df8f28d7a1909be19301ebbfcdddcb',
    'Content-Type' => 'application/json',
  }.freeze

  QUERY = <<~GRAPHQL
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

module_function

  def fetch_repos
    Thread.new do
      body = nil
      (Net::HTTP.new ENDPOINT.host, ENDPOINT.port).tap do |http|
        http.use_ssl = true
      end.start do |http|
        req = Net::HTTP::Post.new ENDPOINT.path, HEADER
        req.body = { query: QUERY }.to_json
        http.request req do |res|
          res.code == '200' or next Deferred.fail res.message
          body = res.body
        end
      end

      data = (JSON.parse body)['data']
      data['search']['nodes'].map do |it|
        Repository.new(
          name: it['name'],
          name_with_owner: it['nameWithOwner'],
          owner: it['owner'].yield_self do |it|
            Owner.new(
              name: it['login'],
              url: it['url'],
              avatar_uri: it['avatarUrl'],
            )
          end,
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
end
