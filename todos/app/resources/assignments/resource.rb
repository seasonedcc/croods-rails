# frozen_string_literal: true

module Assignments
  class Resource < ApplicationResource
    filter_by :task
    remove_actions :show, :update
  end
end
