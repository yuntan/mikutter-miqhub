# frozen_string_literal: true

require_relative 'api'
require_relative 'filesystem'
require_relative 'model/repository'
require_relative 'skin'

Plugin.create :miqhub do
  PM = Plugin::MiqHub

  command(
    :miqhub_list,
    name: (_ 'GitHubでプラグインを探す'),
    condition: ->(_) { !(Plugin.filtering :miqhub_worlds, nil).first.empty? },
    visible: true,
    icon: PM::Skin[:github],
    role: :window,
  ) do
    (Plugin.filtering :tabs, {}).first.keys.include? :miqhub and next

    tab :miqhub, 'GitHub tag:mikutter-plugin' do
      set_icon PM::Skin[:github]
      set_deletable true
      temporary_tab true
      tl = timeline :miqhub do
        order { |repo| repo.modified.to_i }
      end
      active!

      world, = Plugin.filtering :miqhub_current, nil
      api = PM::API.new world.token
      Deferred.next { tl << +api.fetch_repos }
    end
  end

  command(
    :miqhub_about_owner,
    name: ->(opt) \
      { format (_ '%{title}について'), title: opt.messages.first.owner.title },
    condition: lambda do |opt|
      (opt.messages.size == 1) && (opt.messages.first.is_a? PM::Repository)
    end,
    visible: true,
    icon: ->(opt) { opt.messages.first.owner.icon },
    role: :timeline,
  ) do |opt|
    Plugin.call :open, opt.messages.first.owner
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
    # TODO: かわいいアイコンを描く
    icon: PM::Skin[:install],
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
    # TODO: かわいいアイコンを描く
    icon: PM::Skin[:uninstall],
    role: :timeline,
  ) do |opt|
    PM::FileSystem.uninstall! opt.messages.first.idname
  end
end
