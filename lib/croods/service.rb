# frozen_string_literal: true

module Croods
  class Service
    attr_accessor :member_or_collection, :params, :current_user

    def self.about(name = nil)
      return @about unless name

      @about = name
      attr_accessor name
    end

    def self.execute(member_or_collection, params, current_user)
      new(member_or_collection, params, current_user).execute
    end

    def initialize(member_or_collection, params, current_user)
      public_send("#{self.class.about}=", member_or_collection) if self.class.about

      self.member_or_collection = member_or_collection
      self.params = params
      self.current_user = current_user
    end
  end
end
