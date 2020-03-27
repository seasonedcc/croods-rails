# frozen_string_literal: true

module Croods
  module Resource
    module Actions
      def public(*names)
        extend_controller do
          skip_before_action :authenticate_user!, only: names
        end
      end
    end
  end
end
