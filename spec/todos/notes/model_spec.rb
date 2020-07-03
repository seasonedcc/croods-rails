# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Note, type: :model do
  it { is_expected.to belong_to(:assignment).optional }
  it { is_expected.to belong_to(:list) }
  it { is_expected.to validate_presence_of(:text) }
end
