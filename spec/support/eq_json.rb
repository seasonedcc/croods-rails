# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :eq_json do |expected|
  match do |actual|
    convert_value(actual) == convert_value(expected)
  end

  def convert_value(value)
    value = value.to_json unless value.is_a?(String)
    JSON.parse(value)
  end
end
