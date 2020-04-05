# frozen_string_literal: true

module Assignments
  class Resource < ApplicationResource
    filter_by :task
    remove_actions :show, :update
    user_is_not_the_owner!
  end
end
