# frozen_string_literal: true

module Croods
  module Resource
    module Services
      def use_service(service, on: nil)
        name = on || service.to_s.split('::').last.downcase
        actions.find { |action| action.name == name.to_sym }.service = service
      end
    end
  end
end
