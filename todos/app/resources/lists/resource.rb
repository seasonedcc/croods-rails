# frozen_string_literal: true

module Lists
  class Resource < ApplicationResource
    filter_by :project, optional: true

    authorize :owner, :admin, :supervisor

    request do
      ignore_attributes :total_tasks, :finished_tasks, :progress, :status_text
    end
  end
end
