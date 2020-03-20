# frozen_string_literal: true

require_relative 'links/index'
require_relative 'links/create'
require_relative 'links/update'
require_relative 'links/destroy'
require_relative 'links/show'

module Croods
  module Resource
    module JsonSchema
      module Links
        def self.schema(resource)
          [Index, Create, Update, Destroy, Show].map do |action|
            action.link(resource)
          end
        end
      end
    end
  end
end
