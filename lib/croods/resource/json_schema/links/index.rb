# frozen_string_literal: true

module Croods
  module Resource
    module JsonSchema
      module Links
        module Index
          class << self
            def link(resource)
              Collection.link(resource)
            end
          end
        end
      end
    end
  end
end
