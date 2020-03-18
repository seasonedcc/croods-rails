# frozen_string_literal: true

require_relative 'links/index'

module Croods
  module Resource
    module JsonSchema
      module Links
        def self.schema(resource)
          [Index.link(resource)]
        end
      end
    end
  end
end
