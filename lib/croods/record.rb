# frozen_string_literal: true

module Croods
  class Record < ActiveRecord::Base
    self.abstract_class = true
  end
end
