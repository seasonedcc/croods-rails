# frozen_string_literal: true

module Notes
  class Resource < ApplicationResource
    filter_by :list

    extend_model { include Notes::Model }
  end
end
