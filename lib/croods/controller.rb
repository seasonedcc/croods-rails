# frozen_string_literal: true

require_relative 'controller/actions'
require_relative 'controller/not_found'
require_relative 'controller/already_taken'

module Croods
  class Controller < ActionController::API
    include Actions
    include NotFound
    include AlreadyTaken

    protected

    def record
      model.find(params[:id])
    end

    def record_params
      params.require(model_name.downcase).permit!
    end

    def model_name
      self.class.to_s.titleize.split.first.singularize
    end

    def model
      model_name.constantize
    end
  end
end
