# frozen_string_literal: true

module Organizations
  class Resource < ApplicationResource
    authorize :admin
  end
end
