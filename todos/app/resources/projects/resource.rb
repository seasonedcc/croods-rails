# frozen_string_literal: true

module Projects
  class Resource < ApplicationResource
    search_by :search, { against: %i[name] } do |query|
      parse_query_param(query)
    end

    sort_by :name

    add_action :highlighted, on: :collection do
      authorize model
      render json: collection.where(highlighted: true)
    end

    extend_model do
      def parse_query_param(query)
        if date?(query)
          query = format_date_to_db(query)
          where("deadline = '#{query}'")
        else
          search(query)
        end
      end

      def date?(query)
        %r{(\d{2})[-./](\d{2})[-./](\d{4})}.match(query).present?
      end

      def format_date_to_db(date)
        date_split = date.split('/')
        "#{date_split[2]}-#{date_split[0]}-#{date_split[1]}"
      end
    end
  end
end
