# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module Collection
      protected

      # rubocop:disable Metrics/AbcSize
      def collection
        list = resource
          .apply_filters(policy_scope(model), params)
          .order(resource.sort_by)

        return paginate(list.page(params[:page])) if params[:page].present?

        list
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
