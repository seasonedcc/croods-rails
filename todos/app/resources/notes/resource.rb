# frozen_string_literal: true

module Notes
  class Resource < ApplicationResource
    filter_by :list
    sort_by created_at: :desc, text: :asc

    extend_model { include Notes::Model }
  end
end
