# frozen_string_literal: true

Plugin.create :miqhub do
  pm = Plugin::MiqHub

  # failed to parse with ruby 2.4
  # rubocop:disable Style/MethodCallWithArgsParentheses
  intent(pm::Repository, label: (_ 'MiqHubでインストール')) do |token|
    Plugin.call :miqhub_install, token.model
  end
  # rubocop:enable Style/MethodCallWithArgsParentheses
end
