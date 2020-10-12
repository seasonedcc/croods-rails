# frozen_string_literal: true

module Croods
  module Resource
    module Pagination
      def paginate_by
        page = Croods::Attribute.new(
          'page', :string, null: true
        )
        per_page = Croods::Attribute.new(
          'per_page', :string, null: true
        )

        [page, per_page]
      end

      def pagination
        @pagination ||= [] + paginate_by
      end
    end
  end
end
