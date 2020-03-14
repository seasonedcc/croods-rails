# frozen_string_literal: true

module Croods
  class Model < ActiveRecord::Base
    self.abstract_class = true
  end
end
