# frozen_string_literal: true

require_relative 'links/index'
require_relative 'links/create'

module Croods
  module Resource
    module JsonSchema
      module Links
        def self.schema(resource)
          [Index.link(resource), Create.link(resource)]
        end
      end
    end
  end
end
