# frozen_string_literal: true

require_relative 'icon'
require_relative 'github_api'
require_relative 'filesystem'
require_relative 'model/repository'

Plugin.create :miqhub do
  PM = Plugin::MiqHub

  command(
    :miqhub_list,
    name: (_ 'GitHubでプラグインを探す'),
    condition: ->(_) { true },
    visible: true,
    icon: (PM.icon :github),
    role: :window,
  ) do
    (Plugin.filtering :tabs, {}).first.keys.include? :miqhub and next

    tab :miqhub, 'GitHub tag:mikutter-plugin' do
      set_icon PM.icon :github
      set_deletable true
      temporary_tab true
      tl = timeline :miqhub do
        order { |repo| repo.modified.to_i }
      end
      active!

      Deferred.next do
        tl << +PM.fetch_repos
      end
    end
  end

  command(
    :miqhub_install,
    name: ->(opt) \
      { format (_ '%{title}をインストール'), title: opt.messages.first.title },
    condition: lambda do |opt|
      m = opt.messages.first
      (opt.messages.size == 1) \
        && (m.is_a? PM::Repository) \
        && (not PM::FileSystem.installed? m.idname)
    end,
    visible: true,
    icon: (PM.icon :install),
    role: :timeline,
  ) do |opt|
    PM::FileSystem.install! opt.messages.first
  end

  command(
    :miqhub_uninstall,
    name: ->(opt) \
      { format (_ '%{title}をアンインストール'), title: opt.messages.first.title },
    condition: lambda do |opt|
      m = opt.messages.first
      (opt.messages.size == 1) \
        && (m.is_a? PM::Repository) \
        && (PM::FileSystem.installed? m.idname)
    end,
    visible: true,
    icon: (PM.icon :uninstall),
    role: :timeline,
  ) do |opt|
    PM::FileSystem.uninstall! opt.messages.first.idname
  end
end
