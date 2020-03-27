# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) do
    described_class.create!(
      email: 'foo@bar.com',
      name: 'Foo Bar',
      password: 'foobar',
      age: 27,
      bio: 'Foo bar foo'
    )
  end

  before { Timecop.freeze '2020-03-26 13:54:29' }

  after { Timecop.return }

  describe '#as_json' do
    subject { user.as_json }

    let(:as_json) do
      {
        id: user.id,
        email: 'foo@bar.com',
        name: 'Foo Bar',
        age: 27,
        bio: 'Foo bar foo',
        created_at: '2020-03-26T13:54:29Z',
        updated_at: '2020-03-26T13:54:29Z'
      }.stringify_keys
    end

    it { is_expected.to eq(as_json) }
  end
end
