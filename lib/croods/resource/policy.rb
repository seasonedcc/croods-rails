# frozen_string_literal: true

module Croods
  module Resource
    module Policy
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

      def policy_scope(action)
        policy_scope_name(action).constantize
      end

      def policy_name
        "#{model_name}Policy"
      end

      def policy_scope_name(action)
        "#{model_name}#{action.to_s.camelize}Scope"
      end

      def create_policy!
        Object.const_set(policy_name, Class.new(Croods::Policy))
        policy_blocks.each { |block| policy.instance_eval(&block) }
        create_policy_actions!
      end

      def create_policy_actions!
        (actions + additional_actions).each do |action|
          policy.define_method("#{action.name}?") { authorize_action(action) }

          Object.const_set(
            policy_scope_name(action.name), Class.new(Croods::Policy::Scope)
          )

          policy_scope(action.name).define_method(:action) { action }
        end
      end
    end
  end
end
