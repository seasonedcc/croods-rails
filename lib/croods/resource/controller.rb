# frozen_string_literal: true

module Croods
  module Resource
    module Controller
      def extend_controller(&block)
        return unless block

        controller_blocks << block
      end

      def controller_blocks
        @controller_blocks ||= []
      end

      def controller_name
        "#{namespace}Controller"
      end

      def controller
        controller_name.constantize
      end

      def create_controller!
        Object.const_set(controller_name, Class.new(ApplicationController))

        controller_blocks.each do |block|
          controller.instance_eval(&block)
        end

        create_actions!
        create_additional_actions!
      end

      def create_actions!
        actions.each do |action|
          controller.define_method(
            action.name, Croods::Controller::Actions.send(action.name)
          )
        end
      end

      def create_additional_actions!
        additional_actions.each do |action|
          controller.define_method(action.name, &action.block)
        end
      end
    end
  end
end
