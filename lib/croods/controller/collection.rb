# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module Collection
      protected

      def collection
        resource
          .apply_filters(policy_scope(model), params)
          .order(resource.sort_by)
      end
    end
  end
end
