# frozen_string_literal: true

module Projects
  class Resource < ApplicationResource
    filter_by :page, optional: true

    add_action :highlighted, on: :collection do
      authorize model
      render json: collection.where(highlighted: true)
    end
  end
end
