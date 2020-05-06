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
        self.scope = tenant_scope(scope) if Croods.multi_tenancy?

        return scope if action.public

        return scope if super?

        return owner_scope(scope) if owner?

        scope
      end

      protected

      attr_accessor :tenant, :user, :scope

      def scope_is_the_owner?(scope, target)
        return scope.reflect_on_association(target) unless target == :user

        scope.resource.user_is_the_owner? &&
          scope.reflect_on_association(target)
      end

      def reflection_path(scope, target, path = [])
        return path if scope_is_the_owner?(scope, target)

        associations = scope.reflect_on_all_associations(:belongs_to)

        associations.each do |association|
          model = association.class_name.constantize
          expanded_path = path + [association]
          association_path = reflection_path(model, target, expanded_path)
          return association_path unless association_path.empty?
        end

        []
      end

      def joins(path)
        joins = nil

        path.reverse.each do |association|
          joins = joins ? { association.name => joins } : association.name
        end

        joins
      end

      def immediate_tenant_scope(scope)
        scope.where(Croods.tenant_attribute => tenant.id)
      end

      def immediate_tenant_scope?(scope)
        scope.has_attribute?(Croods.tenant_attribute)
      end

      def tenant_scope(scope)
        return immediate_tenant_scope(scope) if immediate_tenant_scope?(scope)

        path = reflection_path(scope, Croods.multi_tenancy_by)
        return scope if path.empty?

        scope.joins(joins(path)).where(
          path.last.plural_name => { Croods.tenant_attribute => tenant.id }
        )
      end

      def user_owner_scope(scope)
        scope.where(id: user.id)
      end

      def user_owner_scope?(scope)
        scope == User || scope.try(:klass) == User
      end

      def immediate_owner_scope(scope)
        scope.where(user_id: user.id)
      end

      def immediate_owner_scope?(scope)
        scope.resource.user_is_the_owner? && scope.has_attribute?(:user_id)
      end

      def owner_scope(scope)
        return user_owner_scope(scope) if user_owner_scope?(scope)

        return immediate_owner_scope(scope) if immediate_owner_scope?(scope)

        path = reflection_path(scope, :user)
        return scope if path.empty?

        scope.joins(joins(path)).where(
          path.last.plural_name => { user_id: user.id }
        )
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
