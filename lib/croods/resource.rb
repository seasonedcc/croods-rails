# frozen_string_literal: true

require_relative 'resource/names'
require_relative 'resource/paths'
require_relative 'resource/model'
require_relative 'resource/attributes'
require_relative 'resource/json_schema'
require_relative 'resource/authentication'

module Croods
  module Resource
    extend ActiveSupport::Concern

    class_methods do
      include Names
      include Paths
      include Model
      include Attributes
      include JsonSchema
      include Authentication

      def create_controller!
        Object.const_set(
          "#{namespace}Controller", Class.new(Croods::Controller)
        )
      end
    end
  end
end
