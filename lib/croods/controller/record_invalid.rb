# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module RecordInvalid
      extend ActiveSupport::Concern

      included do
        rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
      end

      protected

      def record_invalid(exception)
        render status: :unprocessable_entity, json: {
          id: 'record_invalid',
          message: exception.message
        }
      end
    end
  end
end
