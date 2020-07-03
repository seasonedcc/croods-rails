# frozen_string_literal: true

module Notes
  module Model
    extend ActiveSupport::Concern

    included do
      belongs_to :assignment, optional: true

      #schema_validations auto_create: false
    end
  end
end
