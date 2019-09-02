# frozen_string_literal: true

Plugin.create :miqhub do
  filter_miqhub_worlds do
    [Enumerator.new { |y| Plugin.filtering :worlds, y }
      .filter { |world| world.class.slug == :miqhub_world }.to_a]
  end

  # 選択中のworldが:miqhub_worldであればそれを返す
  # それ以外の場合適当な:miqhub_worldを返す
  filter_miqhub_current do
    world, = Plugin.filtering :world_current, nil
    world.class.slug == :miqhub_world and next [world]
    worlds, = Plugin.filtering :miqhub_worlds, nil
    worlds.empty? and next []
    [worlds.first]
  end
end
