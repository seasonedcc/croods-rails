# frozen_string_literal: true

module Users
  module Resource
    include Croods::Resource

    authenticate
  end
end
