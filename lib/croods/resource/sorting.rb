# frozen_string_literal: true

module Croods
  module Resource
    module Sorting
      def sort_by(attribute = nil)
        return @sort_by ||= :created_at unless attribute

        @sort_by = attribute
      end
    end
  end
end
