# frozen_string_literal: true

module Tasks
  class Resource < ApplicationResource
    filter_by :list
    sort_by :sorting

    request do
      ignore_attribute :finished
    end

    add_action :finish, method: :put do
      authorize member
      render json: Finish.execute(member, current_user)
    end

    use_services Create, Destroy, Index, Show, Update
  end
end
