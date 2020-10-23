# frozen_string_literal: true

module Lists
  class Resource < ApplicationResource
    filter_by :project, optional: true

    search_by :search,
              against: %i[
                name status_text
              ],
              associated_against: { project: :name },
              using: { tsearch: { prefix: true } }

    sort_by :sorting

    authorize :owner, :admin, :supervisor

    request do
      skip_attributes :total_tasks, :finished_tasks, :progress, :status_text
    end

    extend_model do
      def self.sorting(order_by = 'created_at', order = 'asc')
        sort = parse_sorting_names(order_by)
        joins(:project).order(sort => order || 'asc')
      end

      def self.parse_sorting_names(order_by)
        return 'projects.name' if order_by == 'project_name'

        order_by
      end
    end
  end
end
