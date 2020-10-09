# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module Collection
      protected

      def collection
        list = resource
          .apply_filters(policy_scope(model), params)
          .order(resource.sort_by)

        return list unless params[:page].present?

        paginate(list.page(params[:page]))
      end
    end
  end
end
