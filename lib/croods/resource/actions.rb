# frozen_string_literal: true

module Croods
  module Resource
    module Actions
      DEFAULT_ACTIONS = %i[index show create update destroy].freeze

      def default_actions
        DEFAULT_ACTIONS.map do |name|
          Croods::Action.new name
        end
      end

      def actions(*names)
        return @actions ||= default_actions if names.empty?

        @actions = names.map do |name|
          Croods::Action.new name
        end
      end
    end
  end
end
