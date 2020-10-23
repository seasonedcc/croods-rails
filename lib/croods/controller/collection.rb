# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module Collection
      protected

      def page_param
        params[resource.page_attribute_name]
      end

      def search_param
        params[resource.search_attribute_name]
      end

      def paginate_collection(list)
        paginate(list.send(resource.page_method_name, page_param))
      end

      def search_collection(list)
        return list unless search_param.present?

        if resource.search_block.present?
          list.instance_exec(search_param, &resource.search_block)
        else
          list.public_send resource.search_method_name, search_param
        end
      end

      def sort(list)
        if resource.sort_by_method?
          list.public_send(resource.sort_by, params[:order_by], params[:order])
        else
          list.order(resource.sort_by)
        end
      end

      def collection
        list = resource.apply_filters(policy_scope(model), params)
        list = search_collection(list) unless resource.skip_search?
        list = sort(list)
        list = paginate_collection(list) if page_param.present?

        list
      end
    end
  end
end
