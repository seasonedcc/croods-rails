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
        return filtered_actions if names.empty?

        @actions = names.map do |name|
          Croods::Action.new name
        end
      end

      def filtered_actions
        @actions ||= default_actions

        @actions.reject { |action| ignored_actions.include?(action.name) }
      end

      def remove_actions(*names)
        names.each do |name|
          ignored_actions << name.to_sym
        end
      end

      def ignored_actions
        @ignored_actions ||= []
      end

      alias remove_action remove_actions
    end
  end
end
