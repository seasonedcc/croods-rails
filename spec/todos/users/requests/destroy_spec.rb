# frozen_string_literal: true

require 'rails_helper'

describe 'DELETE /users/:id', type: :request do
  subject { response }

  let(:user) { User.create! email: 'foo@bar.com', name: 'Foo Bar' }

  before do
    delete "/users/#{user.id}"
  end

  it { is_expected.to have_http_status(:ok) }
  it { expect(response.body).to eq_json(user) }
  it { expect(User.count).to eq(0) }
end
