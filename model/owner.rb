# frozen_string_literal: true

module Plugin::MiqHub
  # GitHubのRepositoryOwnerを表すModel
  class Owner < Diva::Model
    include Diva::Model::UserMixin

    register :miqhub_owner, name: 'GitHub Owner', myself: true

    field.string :name, required: true
    field.uri    :url, required: true
    field.uri    :avatar_uri

    # for basis model
    alias title name
    alias uri url
    alias perma_link url

    # for user model
    alias idname name
    alias profile_image_url avatar_uri
  end
end
