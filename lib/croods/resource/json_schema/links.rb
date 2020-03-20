# frozen_string_literal: true

require_relative 'links/index'
require_relative 'links/create'
require_relative 'links/update'

module Croods
  module Resource
    module JsonSchema
      module Links
        def self.schema(resource)
          [Index, Create, Update].map do |action|
            action.link(resource)
          end
        end
      end
    end
  end
end
