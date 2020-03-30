# frozen_string_literal: true

module Croods
  class Policy
    class Scope
      def initialize(tenant:, user:, scope:)
        self.user  = user
        self.scope = scope
        self.tenant = user&.tenant || tenant
      end

      def resolve
        self.scope = tenant_scope(scope) if multi_tenancy?

        return scope if super?

        return scope unless owner? && scope.has_attribute?(:user_id)

        scope.where(user_id: user.id)
      end

      protected

      attr_accessor :tenant, :user, :scope

      def multi_tenancy?
        return false unless Croods.multi_tenancy?

        scope.has_attribute?(Croods.tenant_attribute) ||
          scope.has_attribute?(:user_id)
      end

      def tenant_scope(scope)
        if scope.has_attribute?(Croods.tenant_attribute)
          return scope.where(Croods.tenant_attribute => tenant.id)
        end

        scope.joins(:user)
          .where(users: { Croods.tenant_attribute => tenant.id })
      end

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
