# frozen_string_literal: true

# iconフォルダー内のリソースを取得する関数を定義
# PNGにしか対応してない
module Plugin::MiqHub
module_function

  def icon(sym)
    path = Pathname(__dir__) / 'icon' / "#{sym}.png"
    uri = Diva::URI.new "file://#{path}"
    (Plugin.filtering :photo_filter, uri, [])[1].first
  end
end
