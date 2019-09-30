# frozen_string_literal: true

Plugin.create :miqhub do
  pm = Plugin::MiqHub

  intent pm::Repository, label: (_ 'MiqHubでインストール') do |token|
    Plugin.call :miqhub_install, token.model
  end
end
