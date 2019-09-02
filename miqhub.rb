# frozen_string_literal: true

require_relative 'command'
require_relative 'filter'
require_relative 'modelviewer'
require_relative 'world'

module Plugin::MiqHub
  PM = Plugin::MiqHub
end

Plugin.create :miqhub do
  PM = Plugin::MiqHub
end
