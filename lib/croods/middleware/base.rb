# frozen_string_literal: true

module Croods
  module Middleware
    class Base
      attr_accessor :app, :options

      def initialize(app, **options)
        self.app = app
        self.options = options
      end

      def call(env)
        committee = self.class.name.gsub('Croods', 'Committee').constantize
          .new(app, options.merge(schema: Croods.json_schema))
        committee.call(env)
      end
    end
  end
end
