# frozen_string_literal: true

module Plugin::MiqHub
  # GitHubのRepositoryOwnerを表すModel
  class Owner < Diva::Model
    include Diva::Model::UserMixin

    register :miqhub_owner, name: 'GitHub Owner', myself: true

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
  end
end
