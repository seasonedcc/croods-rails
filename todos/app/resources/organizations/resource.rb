# frozen_string_literal: true

module Organizations
  class Resource < ApplicationResource
    identifier :slug
    authorize :admin

    skip_search
  end
end
