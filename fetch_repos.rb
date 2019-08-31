# frozen_string_literal: true

require 'json'
require 'uri'
require 'net/http'

require_relative 'model/repository'

module Plugin::MiqHub
  ENDPOINT = URI.parse 'https://api.github.com/graphql'

  HEADER = {
    'Authorization' => 'bearer c291fd91e9df8f28d7a1909be19301ebbfcdddcb',
    'Content-Type' => 'application/json',
  }.freeze

  QUERY = <<~GRAPHQL
    query {
      search(query: "topic:mikutter-plugin", type: REPOSITORY, first: 10) {
        nodes {
          ... on Repository {
            nameWithOwner
            description
            stargazers {
              totalCount
            }
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
    body = nil
    (Net::HTTP.new ENDPOINT.host, ENDPOINT.port).tap do |http|
      http.use_ssl = true
    end.start do |http|
      req = Net::HTTP::Post.new ENDPOINT.path, HEADER
      req.body = { query: QUERY }.to_json
      http.request req do |res|
        res.code == '200' or return nil
        p res.message
        body = res.body
      end
    end

    data = (JSON.parse body)['data']
    data['search']['nodes'].map do |it|
      Repository.new(
        name: it['nameWithOwner'],
        description: it['description'],
        star_count: it['stargazers']['totalCount'],
        created: it['createdAt'],
        modified: it['updatedAt'],
        url: it['url'],
        default_branch_name: it['defaultBranchRef']['name'],
      )
    end
  end
end
