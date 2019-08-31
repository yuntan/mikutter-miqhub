# frozen_string_literal: true

require_relative 'owner'

module Plugin::MiqHub
  # GitHubのRepositoryを表すModel
  class Repository < Diva::Model
    include Diva::Model::MessageMixin
    include Diva::Model::UserMixin

    register :miqhub_repository, name: 'GitHub Repository', timeline: true

    field.string :name, required: true
    field.string :name_with_owner, required: true
    field.has    :owner, Owner, required: true
    field.int    :star_count
    field.bool   :starred?
    field.int    :fork_count
    field.uri    :url, required: true
    field.string :default_branch_name, required: true

    # for message model
    field.string :description, required: true
    field.time   :created, required: true
    field.time   :modified, required: true

    # for basis model
    # https://reference.mikutter.hachune.net/model/2017/05/06/basis-model.html
    alias title name
    alias uri url
    alias perma_link url

    # for message model
    alias user owner

    # for user model and message model
    alias idname name_with_owner

    # for user model
    def icon
      owner.icon
    end

    # for message model
    def favorite?(counterpart=nil)
      # TODO: world, userを検証する
      starred?
    end

    def archive_uri
      URI.parse "#{url}/archive/#{default_branch_name}.tar.gz"
    end

    def to_s
      "MiqHub Repository #{name}"
    end
  end
end
