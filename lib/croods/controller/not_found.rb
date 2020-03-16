# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module NotFound
      extend ActiveSupport::Concern

      included do
        rescue_from ActiveRecord::RecordNotFound, with: :not_found
      end

      protected

      def not_found(exception)
        render status: :not_found, json: {
          id: 'not_found',
          message: exception.message
        }
      end
    end
  end
end
