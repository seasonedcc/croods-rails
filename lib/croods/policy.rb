# frozen_string_literal: true

require_relative 'policy/scope'

module Croods
  class Policy
    DEFAULT_ROLES = %i[owner admin].freeze

    def initialize(user, member)
      self.user = user
      self.member = member
    end

    protected

    cattr_writer :roles
    attr_accessor :user, :member

    def super?(role)
      return role?(role) unless Croods.multi_tenancy? && user && member_user

      role?(role) && member_user.tenant == user.tenant
    end

    def role?(role)
      user&.public_send("#{role}?")
    end

    def owner?
      return true unless member_user

      return false unless user

      member_user == user
    end

    def member_user
      return @member_user if @member_user

      return if member.instance_of?(Class)

      @member_user = reflection_user(member)
    end

    def user_is_the_owner?(record)
      record.respond_to?(:user) && record.resource.user_is_the_owner?
    end

    def reflection_user(record)
      return unless record

      return record.user if user_is_the_owner?(record)

      associations = list_associations(record)

      return if associations.empty?

      associations.each do |association|
        association_user = reflection_user(record.public_send(association.name))
        return association_user if association_user
      end

      nil
    end

    def list_associations(record)
      record.class.reflect_on_all_associations(:belongs_to)
    end

    def other_tenant?(user_to_compare)
      user.tenant != user_to_compare.tenant
    end

    def skip_associations_authorization?
      !Croods.multi_tenancy? || member.instance_of?(Class)
    end

    def other_tenant_user?
      member.respond_to?(:user) && other_tenant?(member.user)
    end

    def authorize_associations
      return true if skip_associations_authorization?
      return false if other_tenant_user?

      associations = list_associations(member)

      return true if associations.empty?

      associations.each do |association|
        association_user = reflection_user(member.public_send(association.name))
        return false if association_user && other_tenant?(association_user)
      end

      true
    end

    def authorize_action(action)
      return true if action.public

      return false unless authorize_associations

      roles = action.roles || DEFAULT_ROLES

      roles.each do |role|
        return true if authorize_role(role)
      end

      false
    end

    def authorize_role(role)
      return owner? if role.to_sym == :owner

      super?(role)
    end
  end
end
