# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module Actions
      class << self
        def index
          lambda do
            authorize model

            json = execute_service(collection, params) do
              collection
            end

            render json: json
          end
        end

        def show
          lambda do
            authorize member

            json = execute_service(member, params) do
              member
            end

            render json: json
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

            json = execute_service(member, member_params) do
              member.update!(member_params)
              member
            end

            render json: json
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
