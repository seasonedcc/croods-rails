# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module Actions
      def index
        render json: model.order(:created_at)
      end

      def show
        render json: member
      end

      def create
        render status: :created, json: model.create!(member_params)
      end

      def update
        member.update!(member_params)
        render json: member
      end

      def destroy
        render json: member.destroy!
      end
    end
  end
end
