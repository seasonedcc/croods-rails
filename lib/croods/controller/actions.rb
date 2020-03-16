# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module Actions
      def index
        render json: model.order(:created_at)
      end

      def show
        render json: record
      end

      def create
        render status: :created, json: model.create!(record_params)
      end

      def update
        record.update!(record_params)
        render json: record
      end

      def destroy
        render json: record.destroy!
      end
    end
  end
end
