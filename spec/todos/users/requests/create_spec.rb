# frozen_string_literal: true

require 'rails_helper'

describe 'POST /users', type: :request do
  subject { response }

  let(:params) { { email: 'foo@bar.com', name: 'Foo Bar' } }

  before do
    post '/users', params: params.to_json
  end

  it { is_expected.to have_http_status(:created) }
  it { expect(response.body).to eq_json(User.first) }
end
