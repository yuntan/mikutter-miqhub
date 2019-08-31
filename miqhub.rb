# frozen_string_literal: true

require_relative 'command'
require_relative 'model/repository'

module Plugin::MiqHub
  PM = Plugin::MiqHub
end

Plugin.create :miqhub do
  PM = Plugin::MiqHub

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
