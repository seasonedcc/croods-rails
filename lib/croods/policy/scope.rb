# frozen_string_literal: true

module Croods
  class Policy
    class Scope
      def initialize(user, scope)
        self.user  = user
        self.scope = scope
      end

      def resolve
        return scope if super?

        return scope unless owner? && scope.has_attribute?(:user_id)

        scope.where(user_id: user.id)
      end

      protected

      attr_accessor :user, :scope

      def super?
        super_roles.each do |role|
          return true if user&.send("#{role}?")
        end

        false
      end

      def roles
        action.roles || DEFAULT_ROLES
      end

      def super_roles
        roles.reject { |role| role == :owner }
      end

      def owner?
        roles.include?(:owner)
      end
    end
  end
end
