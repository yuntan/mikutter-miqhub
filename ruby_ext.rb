# frozen_string_literal: true

# Enumerable#filter is available only since 2.6.0
unless Enumerable.instance_methods.include? :filter
  # Add an alias added in Ruby >= 2.6
  module Enumerable
    alias filter select
  end
end
