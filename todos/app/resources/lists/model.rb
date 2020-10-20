# frozen_string_literal: true

module Lists
  module Model
    extend ActiveSupport::Concern

    included do
      include PgSearch::Model

      pg_search_scope :search,
                      against: %i[
                        name status_text
                      ],
                      associated_against: { project: :name },
                      using: { tsearch: { prefix: true } }

      def self.sorting(order_by, order)
        sort = parse_sorting_names(order_by) || 'created_at'
        joins(:project).order(sort => order || 'asc')
      end

      def self.parse_sorting_names(order_by)
        return 'projects.name' if order_by == 'project_name'

        order_by
      end
    end
  end
end
