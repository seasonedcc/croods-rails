# frozen_string_literal: true

require 'rails_helper'

describe 'GET /users', type: :request do
  subject { response }

  let!(:user) { User.create! email: 'foo@bar.com', name: 'Foo Bar' }

  before do
    get '/users'
  end

  it { is_expected.to have_http_status(:ok) }
  it { expect(response.body).to eq_json([user]) }
end
