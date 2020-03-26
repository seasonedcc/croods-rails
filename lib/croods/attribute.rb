# frozen_string_literal: true

module Croods
  class Attribute
    attr_accessor :name, :type, :null, :default, :default_function

    def initialize(name, type, **options)
      self.name = name.to_s
      self.type = type
      self.null = options[:null]
      self.default = options[:default]
      self.default_function = options[:default_function]
    end
  end
end
