# frozen_string_literal: true

require_relative 'attributes/base'
require_relative 'attributes/request'
require_relative 'attributes/response'

module Croods
  module Resource
    module Attributes
      include Base

      def request(&block)
        Request.instance_eval(&block)
      end

      def response(&block)
        Response.instance_eval(&block)
      end

      def merged_attributes(type, hash = nil)
        (hash || attributes)
          .merge(type.additional_attributes)
          .reject { |name| type.ignored_attributes.include?(name) }
      end

      def request_attributes
        merged_attributes(Request)
      end

      def response_attributes
        merged_attributes(Response)
      end

      def attributes
        merged_attributes(self, model.columns_hash)
      end

      def definitions
        attributes
          .merge(Request.additional_attributes)
          .merge(Response.additional_attributes)
      end
    end
  end
end
