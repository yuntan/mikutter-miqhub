# frozen_string_literal: true

module Plugin::MiqHub
  # GitHubのレポジトリを表すModel
  class Repository < Diva::Model
    include Diva::Model::MessageMixin
    include Diva::Model::UserMixin

    register :miqhub_repository, name: 'MiqHub Repository', timeline: true

    field.string :name, required: true
    # should be implemented for message model
    field.string :description, required: true
    field.int    :star_count
    field.time   :created, required: true
    field.time   :modified, required: true
    field.uri    :url, required: true
    field.string :default_branch_name, required: true

    # for basis model
    # https://reference.mikutter.hachune.net/model/2017/05/06/basis-model.html
    alias title name
    alias uri url
    alias perma_link url

    # for user model
    alias idname name

    # should be implemented for message model
    def user
      self
    end

    # for user model
    def icon
      Skin[:github]
    end

    def to_s
      "MiqHub Repository #{name}"
    end
  end
end
