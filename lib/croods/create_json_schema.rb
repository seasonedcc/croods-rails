# frozen_string_literal: true

module Croods
  class CreateJsonSchema
    def self.execute
      new.execute
    end

    attr_accessor :schema

    def initialize
      json = File.read(File.expand_path('initial_schema.json', __dir__))
      self.schema = JSON.parse(json)
    end

    def execute
      Committee::Drivers::HyperSchema::Driver.new.parse(schema)
    end
  end
end
