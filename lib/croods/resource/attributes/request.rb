# frozen_string_literal: true

require_relative 'base'

module Croods
  module Resource
    module Attributes
      class Request
        include Base

        attr_accessor :ignore_user

        def initialize(ignore_user:)
          self.ignore_user = ignore_user
        end

        def ignored_attributes
          @ignored_attributes ||= default_ignored_attributes
        end

        def default_ignored_attributes
          return [] unless ignore_user

          ['user_id']
        end
      end
    end
  end
end
