# frozen_string_literal: true

require_relative 'resource/names'
require_relative 'resource/paths'
require_relative 'resource/identifier'
require_relative 'resource/model'
require_relative 'resource/policy'
require_relative 'resource/controller'
require_relative 'resource/actions'
require_relative 'resource/attributes'
require_relative 'resource/json_schema'
require_relative 'resource/authentication'
require_relative 'resource/authorization'
require_relative 'resource/filters'
require_relative 'resource/pagination'
require_relative 'resource/sorting'
require_relative 'resource/search'
require_relative 'resource/services'

module Croods
  module Resource
    extend ActiveSupport::Concern

    class_methods do
      include Names
      include Paths
      include Identifier
      include Model
      include Policy
      include Controller
      include Actions
      include Attributes
      include JsonSchema
      include Authentication
      include Authorization
      include Filters
      include Pagination
      include Sorting
      include Search
      include Services
    end
  end
end
