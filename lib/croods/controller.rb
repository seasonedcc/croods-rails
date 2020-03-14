# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    def index
      render json: model.order(:created_at)
    end

    private

    def model_name
      self.class.to_s.titleize.split.first.singularize
    end

    def model
      model_name.constantize
    end
  end
end
