# frozen_string_literal: true

module Croods
  class Action
    attr_accessor :name, :public, :roles

    def initialize(name, **options)
      self.name = name.to_sym
      self.public = options[:public]
      self.roles = options[:roles]
    end
  end
end
