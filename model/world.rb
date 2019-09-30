# frozen_string_literal: true

module Plugin::MiqHub
  # GitHubを表すWorld
  class World < Diva::Model
    NAME = 'GitHub'
    URL = URI.parse 'https://github.com'

    register :miqhub_world, name: "#{NAME} World"

    field.string :slug, required: true
    field.has    :me, Owner, required: true
    field.string :token, required: true

    def icon
      Skin[:github]
    end

    def title
      NAME
    end

    def url
      URL
    end

    alias uri url
    alias perma_link url

    def to_s
      "#{NAME} World (#{me.title})"
    end
  end
end
