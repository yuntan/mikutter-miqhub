# frozen_string_literal: true

require_relative 'command'
require_relative 'modelviewer'

module Plugin::MiqHub
  PM = Plugin::MiqHub
end

Plugin.create :miqhub do
  PM = Plugin::MiqHub
end
