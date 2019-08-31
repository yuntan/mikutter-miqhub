# frozen_string_literal: true

require_relative 'icon'
require_relative 'github_api'
require_relative 'filesystem'

Plugin.create :miqhub do
  PM = Plugin::MiqHub

  command(
    :miqhub_list,
    name: _('GitHubでプラグインを探す'),
    condition: ->(_) { tabs },
    visible: true,
    icon: (PM.icon :github),
    role: :window,
  ) do
    tab :miqhub, _('MiqHub') do
      set_icon PM.icon :github
      set_deletable true
      temporary_tab true
      tl = timeline :miqhub do
        # order :modified
      end
      PM.fetch_repos.each do |repo|
        tl << repo
      end
      active!
    end
  end

  command(
    :miqhub_install,
    name: _('インストール'),
    condition: ->(opt) \
      { opt.messages.any? { |m| not PM::FileSystem.installed? m.idname } },
    visible: true,
    icon: (PM.icon :install),
    role: :timeline,
  ) do |opt|
    opt.messages
      .filter { |m| not PM::FileSystem.installed? m.idname }
      .each { |m| PM::FileSystem.install! m }
  end

  command(
    :miqhub_uninstall,
    name: _('アンインストール'),
    condition: ->(opt) \
      { opt.messages.any? { |m| PM::FileSystem.installed? m.idname } },
    visible: true,
    icon: (PM.icon :uninstall),
    role: :timeline,
  ) do |opt|
    opt.messages
      .filter { |m| PM::FileSystem.installed? m.idname }
      .each { |m| PM::FileSystem.uninstall! m.idname }
  end
end
