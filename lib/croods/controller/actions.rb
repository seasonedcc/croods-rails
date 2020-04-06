# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module Actions
      class << self
        def index
          lambda do
            authorize model
            render json: collection
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
            member = new_member

            authorize member
            json = execute_service(member, member_params) do
              member.save!
              member
            end

            render status: :created, json: json
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
            json = execute_service(member, params) do
              member.destroy!
            end

            render json: json
          end
        end
      end
    end
  end
end
