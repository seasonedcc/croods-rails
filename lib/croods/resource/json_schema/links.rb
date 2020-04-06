# frozen_string_literal: true

require_relative 'links/collection'
require_relative 'links/index'
require_relative 'links/create'
require_relative 'links/update'
require_relative 'links/destroy'
require_relative 'links/show'

module Croods
  module Resource
    module JsonSchema
      module Links
        class << self
          def schema(resource)
            additional_actions(resource) + actions(resource)
          end

          def actions(resource)
            resource.actions.map do |action|
              action_module(action.name).link(resource)
            end
          end

          def additional_actions(resource)
            resource.additional_actions.map do |action|
              action_module(action.on).link(resource, action)
            end
          end

          def action_module(name)
            "Croods::Resource::JsonSchema::Links::#{name.to_s.titleize}"
              .constantize
          end
        end
      end
    end
  end
end
