# frozen_string_literal: true

module Lists
  class Resource < ApplicationResource
    filter_by :project, optional: true
  end
end
