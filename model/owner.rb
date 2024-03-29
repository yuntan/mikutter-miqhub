# frozen_string_literal: true

module Plugin::MiqHub
  # GitHubのRepositoryOwnerを表すModel
  class Owner < Diva::Model
    RE_URL = %r{^https://github.com/(?<name>[^/]+)$}.freeze

    include Diva::Model::UserMixin

    register :miqhub_owner, name: 'GitHub Owner', myself: true

    handle RE_URL do |uri|
      world, = Plugin.filtering :miqhub_current, nil
      world or return
      m = RE_URL.match uri.to_s
      (API.new world.token).fetch_owner m[:name]
    end

    field.string :idname, required: true
    field.uri    :url, required: true
    field.uri    :avatar_url
    field.int    :repo_count

    # for basis model
    alias title idname
    alias uri url
    alias perma_link url

    # for user model
    alias profile_image_url avatar_url

    def to_s
      "MiqHub::Owner(#{idname})"
    end
  end
end
