# frozen_string_literal: true

require_relative 'skin'

Plugin.create :miqhub do
  pm = Plugin::MiqHub

  command :miqhub_list,
          name: (_ 'GitHubでプラグインを探す'),
          condition: proc {
            world, = Plugin.filtering :miqhub_worlds, nil
            !world.empty?
          },
          visible: true,
          icon: pm::Skin[:github],
          role: :window \
  do
    tabs, = Plugin.filtering :tabs, {}
    tabs.keys.include? :miqhub and next

    tab :miqhub, 'GitHub tag:mikutter-plugin' do
      set_icon pm::Skin[:github]
      set_deletable true
      temporary_tab true
      tl = timeline :miqhub do
        order { |repo| repo.modified.to_i }
      end
      active!

      world, = Plugin.filtering :miqhub_current, nil
      api = pm::API.new world.token
      Deferred.next { tl << +api.fetch_repos }
    end
  end

  command :miqhub_about_owner,
          name: proc {
            format (_ '%{title}について'),
                   title: (opt and opt.messages.first.owner.title or '…')
          },
          condition: proc { |opt|
            (opt.messages.size == 1) \
              && (opt.messages.first.is_a? pm::Repository)
          },
          visible: true,
          icon: proc { |opt| opt and opt.messages.first.owner.icon },
          role: :timeline \
  do |opt|
    Plugin.call :open, opt.messages.first.owner
  end

  command :miqhub_install,
          name: proc { |opt|
            format (_ '%{title}をインストール'),
                   title: (opt and opt.messages.first.title or '…')
          },
          condition: proc { |opt|
            m = opt.messages.first
            (opt.messages.size == 1) \
              && (m.is_a? pm::Repository) \
              && (not pm::FileSystem.installed? m.idname)
          },
          visible: true,
          # TODO: かわいいアイコンを描く
          icon: pm::Skin[:install],
          role: :timeline \
  do |opt|
    PM::FileSystem.install! opt.messages.first
  end

  command :miqhub_uninstall,
          name: proc { |opt|
            format (_ '%{title}をアンインストール'),
                   title: (opt and opt.messages.first.title or '…')
          },
          condition: proc { |opt|
            m = opt.messages.first
            (opt.messages.size == 1) \
              && (m.is_a? pm::Repository) \
              && (pm::FileSystem.installed? m.idname)
          },
          visible: true,
          # TODO: かわいいアイコンを描く
          icon: pm::Skin[:uninstall],
          role: :timeline \
  do |opt|
    PM::FileSystem.uninstall! opt.messages.first.idname
  end
end
