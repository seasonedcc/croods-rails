# frozen_string_literal: true

require_relative 'base'

module Croods
  module Resource
    module Attributes
      class Request
        include Base

        def ignored_attributes
          @ignored_attributes ||= ['user_id']
        end
      end
    end
  end
end
