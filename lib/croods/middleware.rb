# frozen_string_literal: true

require_relative 'middleware/request_validation'
require_relative 'middleware/response_validation'

module Croods
  module Middleware
    METHODS = %i[get post put patch delete options head].freeze

    EXPOSE_HEADERS = %w[
      access-token expiry token-type uid client Authorization Link Total
      Per-Page
    ].freeze

    def self.insert!
      insert_cors!
      insert_request_validation!
      insert_response_validation!
    end

    def self.insert_cors!
      Rails.application.config.middleware.insert_before 0, Rack::Cors do
        allow do
          origins '*'
          resource '*', headers: :any, expose: EXPOSE_HEADERS, methods: METHODS
        end
      end
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
