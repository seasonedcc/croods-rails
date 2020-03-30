# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module Actions
      class << self
        def index
          lambda do
            authorize model
            render json: policy_scope(model).order(:created_at)
          end
        end

        def show
          lambda do
            authorize member
            render json: member
          end
        end

        def create
          lambda do
            authorize model
            render status: :created, json: policy_scope(model)
              .create!(
                member_params
                  .merge(tenant_params(model))
                  .merge(user_params(model))
              )
          end
        end

        def update
          lambda do
            authorize member
            member.update!(member_params)
            render json: member
          end
        end

        def destroy
          lambda do
            authorize member
            render json: member.destroy!
          end
        end
      end
    end
  end
end
