# frozen_string_literal: true

module Plugin::MiqHub
  PM = Plugin::MiqHub
end

# models
require_relative 'model_ext'

# classes and modules
require_relative 'api'
require_relative 'filesystem'
require_relative 'skin'

Plugin.create :miqhub do
  defactivity :miqhub, 'MiqHub'
end

# plugin
require_relative 'command'
require_relative 'filter'
require_relative 'intent'
require_relative 'modelviewer'
require_relative 'world'
