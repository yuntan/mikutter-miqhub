# frozen_string_literal: true

require_relative 'model_ext'

require_relative 'api'
require_relative 'command'
require_relative 'fetch'
require_relative 'filesystem'
require_relative 'filter'
require_relative 'intent'
require_relative 'modelviewer'
require_relative 'world'

module Plugin::MiqHub
  PM = Plugin::MiqHub
end

Plugin.create :miqhub do
  defactivity :miqhub, 'MiqHub'
end
