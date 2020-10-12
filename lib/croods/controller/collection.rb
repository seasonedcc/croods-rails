# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module Collection
      protected

      def page_param
        params[resource.page_attribute_name]
      end

      def paginate_collection(list)
        paginate(list.send(resource.page_method_name, page_param))
      end

      def collection
        list = resource
          .apply_filters(policy_scope(model), params)
          .order(resource.sort_by)

        list = paginate_collection(list) if page_param.present?

        list
      end
    end
  end
end
