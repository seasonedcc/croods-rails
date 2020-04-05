# frozen_string_literal: true

module Croods
  module Resource
    module Authorization
      def authorize(*roles, on: nil)
        return if roles.empty?

        on = [on] if on&.is_a?(Symbol)

        actions.each do |action|
          next if on && !on.include?(action.name)

          action.roles = roles
        end
      end

      def public(*names)
        return unless names

        names = [names] if names&.is_a?(Symbol)

        extend_controller do
          skip_before_action :authenticate_user!, only: names
        end

        actions.each do |action|
          next unless names.include?(action.name)

          action.public = true
        end
      end

      def user_is_not_the_owner!
        @user_is_the_owner = false
      end

      def user_is_the_owner?
        return @user_is_the_owner unless @user_is_the_owner.nil?

        @user_is_the_owner = true
      end
    end
  end
end
