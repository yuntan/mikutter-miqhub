# frozen_string_literal: true

require_relative 'model/owner'
require_relative 'model/repository'
require_relative 'model/world'

# Diva::Model#to_yamlを追加
class Diva::Model
  def to_yaml
    dump_for_yaml = lambda do |model|
      model.class.fields.map do |field|
        k = field.name
        v = (model.fetch k).yield_self do |v|
          case v
          when Diva::Model
            dump_for_yaml.call v
          when Diva::URI, URI::Generic
            v.to_s
          when Time
            v.iso8601
          else
            v
          end
        end
        [k.to_s, v]
      end.yield_self { |a| Hash[a] }
    end

    (dump_for_yaml.call self).to_yaml
  end
end
