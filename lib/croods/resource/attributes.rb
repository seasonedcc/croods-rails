# frozen_string_literal: true

require_relative 'attributes/base'
require_relative 'attributes/request'
require_relative 'attributes/response'

module Croods
  module Resource
    module Attributes
      include Base

      def request(&block)
        request_instance.instance_eval(&block)
      end

      def response(&block)
        response_instance.instance_eval(&block)
      end

      def request_instance
        @request_instance ||= Request.new(ignore_user: user_is_the_owner?)
      end

      def response_instance
        @response_instance ||= Response.new
      end

      def merged_attributes(type, hash = nil)
        (hash || attributes)
          .merge(type.additional_attributes)
          .reject { |name| type.ignored_attributes.include?(name) }
      end

      def request_attributes
        merged_attributes(request_instance)
      end

      def response_attributes
        merged_attributes(response_instance)
      end

      def attributes
        merged_attributes(self, model.columns_hash)
      end

      def attribute_names
        attributes.map { |key, _| key }
      end

      def definitions
        attributes
          .merge(request_instance.additional_attributes)
          .merge(response_instance.additional_attributes)
      end
    end
  end
end
