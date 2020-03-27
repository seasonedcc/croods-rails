# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module Actions
      def index
        authorize model
        render json: policy_scope(model).order(:created_at)
      end

      def show
        authorize member
        render json: member
      end

      def create
        authorize model
        render status: :created, json: policy_scope(model)
          .create!(member_params)
      end

      def update
        authorize member
        member.update!(member_params)
        render json: member
      end

      def destroy
        authorize member
        render json: member.destroy!
      end
    end
  end
end
