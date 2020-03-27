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
        Object.const_set(
          controller_name, Class.new(Croods::Controller)
        )

        controller_blocks.each do |block|
          controller.instance_eval(&block)
        end
      end
    end
  end
end
