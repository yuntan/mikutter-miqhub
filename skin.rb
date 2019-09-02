# frozen_string_literal: true

module Plugin::MiqHub
  # skinフォルダー内のリソースを取得するためのSkinのwrapper
  module Skin
    DIR = (Pathname __dir__) / 'skin'
    GITHUB_FAVICON_URL = URI.parse 'https://github.githubassets.com/favicon.ico'

  # module_function
    extend self

    def photo(name)
      # TODO: かわいいアイコンを描く
      name == :github \
        and return (Plugin.filtering :photo, GITHUB_FAVICON_URL, []).first
      # fallbackのディレクトリを指定
      ::Skin.photo name, [DIR]
    end
    alias [] photo
  end
end
