# frozen_string_literal: true

module Users
  class Resource < ApplicationResource
    use_for_authentication!
    authorize :admin, on: :destroy
    authorize :admin, :supervisor, on: %i[create update]

    sort_by :custom_sort

    public_actions :index, :show

    extend_model do
      def custom_sort
        order(:email)
      end
    end
  end
end
