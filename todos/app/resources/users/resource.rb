# frozen_string_literal: true

module Users
  class Resource < ApplicationResource
    use_for_authentication!
    authorize :admin, on: :destroy
    authorize :admin, :supervisor, on: %i[create update]

    public :index, :show
  end
end
