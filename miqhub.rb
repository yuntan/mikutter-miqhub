# frozen_string_literal: true

require_relative 'fetch_repos'

Plugin.create :miqhub do
  PM = Plugin::MiqHub

  command(
    :miqhub_list,
    name: _('GitHubでプラグインを探す'),
    condition: ->(_) { true },
    visible: true,
    icon: Skin[:github],
    role: :window,
  ) do
    tab :miqhub, _('MiqHub') do
      set_icon Skin[:github]
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

  # defspell :favorite
  #
  # defspell :unfavorite
  #
  # defspall :install
  #
  # defspall :uninstall

  defmodelviewer PM::Repository do |repo|
    [
      [_('名前'), repo.name],
      [_('説明'), repo.description],
      ['Star', repo.star_count],
      [_('最終更新日'), repo.modified],
      [_('作成日'), repo.created],
    ]
  end

  deffragment PM::Repository, :readme, _('説明') do |repo|
    set_icon repo.icon
    nativewidget((Gtk::Label.new repo.description).tap do |label|
      label.selectable = true
    end)
  end
end
