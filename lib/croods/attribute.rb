# frozen_string_literal: true

module Croods
  class Attribute
    attr_accessor :name, :type, :null, :default, :default_function

    def initialize(name, type, null: nil, default: nil, default_function: nil)
      self.name = name.to_s
      self.type = type
      self.null = null
      self.default = default
      self.default_function = default_function
    end
  end
end
