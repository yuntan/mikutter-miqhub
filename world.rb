# frozen_string_literal: true

require_relative 'api'
require_relative 'model/world'

Plugin.create :miqhub do
  TOKENS_URL = URI.parse 'https://github.com/settings/tokens'

  world_setting :miqhub, PM::World::NAME do
    token = nil
    loop do
      label _ 'Webページを開いてトークンを発行し，下のフォームに貼り付けて，次へボタンを押して下さい．'
      link TOKENS_URL
      input (_ 'トークン'), :token
      result = await_input

      token = result[:token]
      (token && !token.empty?) and break
      label _ '認証コードを入力してください'
      await_input
    end

    api = PM::API.new token
    # Dialog DSLでDeferredコンテキストを使いたい病
    # me = +api.fetch_me
    me = api.fetch_me!

    label _('認証に成功しました。このアカウントを追加しますか？')
    label format (_ 'アカウント名：%{title}'), title: me.title

    PM::World.new(
      slug: :"#{PM::World::NAME}:#{me.idname}",
      me: me,
      token: token,
    )
  end
end
