# frozen_string_literal: true

module Croods
  class Model < ActiveRecord::Base
    self.abstract_class = true

    def self.resource_name
      to_s.pluralize
    end

    def self.resource
      "#{resource_name}::Resource".constantize
    end

    def as_json(_options = {})
      attributes = {}

      resource.response_attributes.each do |name, attribute|
        value = send(name)
        value = value.iso8601 if value && attribute.type == :datetime
        attributes[name] = value
      end

      attributes
    end

    def tenant
      return unless Croods.multi_tenancy?

      public_send(Croods.multi_tenancy_by)
    end

    def resource_name
      self.class.to_s.pluralize
    end

    def resource
      "#{resource_name}::Resource".constantize
    end
  end
end
