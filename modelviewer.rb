# frozen_string_literal: true

require_relative 'model/owner'
require_relative 'model/repository'

Plugin.create :miqhub do
  pm = Plugin::MiqHub

  defmodelviewer pm::Repository do |repo|
    [
      [_('名前'), repo.name_with_owner],
      [_('説明'), repo.description],
      ['Star', repo.star_count],
      ['Fork', repo.fork_count],
      [_('最終更新日'), repo.modified],
      [_('作成日'), repo.created],
      ['URL', repo.url],
    ]
  end

  deffragment pm::Repository, :readme, _('説明') do |repo|
    set_icon repo.icon
    label = Gtk::Label.new.tap do |label|
      label.text = repo.description
      label.wrap = true
      label.selectable = true
    end
    nativewidget Gtk::VBox.new.closeup label
  end

  defmodelviewer pm::Owner do |owner|
    [
      [(_ '名前'), owner.idname],
      [(_ 'リポジトリ数'), owner.repo_count],
      ['URL', owner.url],
    ]
  end
end
