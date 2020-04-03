# frozen_string_literal: true

module Croods
  module Resource
    module Identifier
      def identifier(attribute = nil)
        return @identifier ||= :id unless attribute

        @identifier = attribute
      end
    end
  end
end
