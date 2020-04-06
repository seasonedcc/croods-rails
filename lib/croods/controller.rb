# frozen_string_literal: true

require_relative 'controller/actions'
require_relative 'controller/authentication'
require_relative 'controller/authorization'
require_relative 'controller/multi_tenancy'
require_relative 'controller/resource'
require_relative 'controller/model'
require_relative 'controller/member'
require_relative 'controller/collection'
require_relative 'controller/not_found'
require_relative 'controller/already_taken'
require_relative 'controller/record_invalid'

module Croods
  class Controller < ActionController::API
    include Authentication
    include Authorization
    include MultiTenancy
    include Resource
    include Model
    include Member
    include Collection
    include NotFound
    include AlreadyTaken
    include RecordInvalid
  end
end
