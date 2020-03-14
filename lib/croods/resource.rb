# frozen_string_literal: true

module Croods
  class Resource
    def initialize
      puts model_class
      Object.const_set(model_class, Class.new(Record))
    end

    private

    def model_class
      ActiveSupport::Inflector.singularize(namespace)
    end

    def namespace
      self.class.to_s.split('::').first
    end
  end
end
