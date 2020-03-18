# frozen_string_literal: true

require_relative 'middleware/request_validation'
require_relative 'middleware/response_validation'

module Croods
  module Middleware
    def self.insert!
      insert_request_validation!
      insert_response_validation!
    end

    def self.insert_request_validation!
      Rails.application.config.middleware.insert_before(
        ActionDispatch::Executor,
        Middleware::RequestValidation
      )
    end

    def self.insert_response_validation!
      Rails.application.config.middleware.insert_after(
        ActionDispatch::Callbacks,
        Middleware::ResponseValidation
      )
    end
  end
end
