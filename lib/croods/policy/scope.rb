# frozen_string_literal: true

module Croods
  class Policy
    class Scope
      def initialize(user, scope)
        @user  = user
        @scope = scope
      end

      def resolve
        return scope if user&.admin?

        return scope unless scope.has_attribute? :user_id

        scope.where(user_id: user.id)
      end

      protected

      attr_reader :user, :scope
    end
  end
end
