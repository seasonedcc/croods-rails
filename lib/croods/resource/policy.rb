# frozen_string_literal: true

module Croods
  module Resource
    module Policy
      def authorize(*roles, on: nil)
        return if roles.empty?

        on = [on] if on&.is_a?(Symbol)

        actions.each do |action|
          next if on && !on.include?(action.name)

          action.roles = roles
        end
      end

      def public(*names)
        return unless names

        names = [names] if names&.is_a?(Symbol)

        extend_controller do
          skip_before_action :authenticate_user!, only: names
        end

        actions.each do |action|
          next unless names.include?(action.name)

          action.public = true
        end
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

      def policy_scope(action)
        policy_scope_name(action).constantize
      end

      def policy_name
        "#{model_name}Policy"
      end

      def policy_scope_name(action)
        "#{model_name}#{action.to_s.titleize}Scope"
      end

      def create_policy!
        Object.const_set(policy_name, Class.new(Croods::Policy))
        policy_blocks.each { |block| policy.instance_eval(&block) }
        create_policy_actions!
      end

      def create_policy_actions!
        actions.each do |action|
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
