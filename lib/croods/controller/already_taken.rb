# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module AlreadyTaken
      extend ActiveSupport::Concern

      included do
        rescue_from ActiveRecord::RecordNotUnique, with: :already_taken
      end

      protected

      def already_taken(exception)
        match = exception.message.match(/\((.+)\)=\(.+\) already exists/)
        attribute = match && match[1].capitalize

        message = attribute ? "#{attribute} already taken" : 'Already taken'

        render status: :unprocessable_entity, json: {
          id: 'already_taken',
          message: message
        }
      end
    end
  end
end
