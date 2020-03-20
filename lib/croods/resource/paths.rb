# frozen_string_literal: true

module Croods
  module Resource
    module Paths
      def collection_path
        "/#{route_name}"
      end

      def member_path
        "/#{route_name}/{(%23%2Fdefinitions" \
          "%2F#{resource_name}%2Fdefinitions%2Fid)}"
      end
    end
  end
end
