# frozen_string_literal: true

require_relative 'policy/scope'

module Croods
  class Policy
    DEFAULT_ROLES = %i[owner admin].freeze

    def initialize(user, member)
      self.user = user
      self.member = member
    end

    def index?
      owner_or_admin?
    end

    def show?
      owner_or_admin?
    end

    def create?
      owner_or_admin?
    end

    def update?
      owner_or_admin?
    end

    def destroy?
      owner_or_admin?
    end

    protected

    cattr_writer :roles
    attr_accessor :user, :member

    def roles
      @roles || DEFAULT_ROLES
    end

    def owner_or_admin?
      owner? || admin?
    end

    def admin?
      user&.admin?
    end

    def owner?
      return true unless member.has_attribute? :user_id

      return false unless user

      member.user_id == user.id
    end
  end
end
