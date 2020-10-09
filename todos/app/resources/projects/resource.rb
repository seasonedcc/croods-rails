# frozen_string_literal: true

module Projects
  class Resource < ApplicationResource
    add_action :highlighted, on: :collection do
      authorize model
      render json: collection.where(highlighted: true)
    end
  end
end
