# frozen_string_literal: true

require_relative 'policy/scope'

module Croods
  class Policy
    attr_reader :user, :member

    def initialize(user, member)
      @user = user
      @member = member
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
