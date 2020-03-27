# frozen_string_literal: true

module Croods
  module Resource
    module Policy
      def authorize(*roles, actions: nil)
        return if roles.empty?
      end

      def extend_policy(&block)
        return unless block

        policy_blocks << block
      end

      def policy_blocks
        @policy_blocks ||= []
      end

      def policy
        policy_name.constantize
      end

      def policy_name
        "#{model_name}Policy"
      end

      def create_policy!
        Object.const_set(policy_name, Class.new(Croods::Policy))

        policy_blocks.each do |block|
          policy.instance_eval(&block)
        end
      end
    end
  end
end
