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

    def admin?
      user&.admin?
    end

    def owner?
      return true unless member.has_attribute? :user_id

      return false unless user

      member.user_id == user.id
    end

    def authorize_action(action)
      return true if action.public

      roles = action.roles || DEFAULT_ROLES

      roles.each do |role|
        return true if authorize_role(role)
      end

      false
    end

    def authorize_role(role)
      name = "#{role}?"
      return send(name) if respond_to?(name, true)

      return user.send(name) if user.respond_to?(name)

      false
    end
  end
end
