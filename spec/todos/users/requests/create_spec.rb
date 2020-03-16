# frozen_string_literal: true

require 'rails_helper'

describe 'POST /users', type: :request do
  subject { response }

  let(:params) { { email: 'foo@bar.com', name: 'Foo Bar' } }

  context 'with valid params' do
    before do
      post '/users', params: params.to_json
    end

    it { is_expected.to have_http_status(:created) }
    it { expect(response.body).to eq_json(User.first) }
  end

  context 'with email already taken' do
    let(:error) do
      {
        id: 'already_taken',
        message: 'E-mail already taken'
      }
    end

    before do
      User.create! email: 'foo@bar.com', name: 'Foo Bar'
      post '/users', params: params.to_json
    end

    it { is_expected.to have_http_status(:unprocessable_entity) }
    it { expect(response.body).to eq_json(error) }
  end
end
