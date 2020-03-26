# frozen_string_literal: true

require 'rails_helper'

describe 'GET /users', type: :request do
  subject { response }

  let!(:user) do
    User.create! email: 'foo@bar.com', name: 'Foo Bar', password: 'foobar'
  end

  context 'with valid request' do
    before do
      get '/users'
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json([user]) }
  end

  context 'with invalid request' do
    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/user/links/0/schema: "foo" is not a ' \
          'permitted key.'
      }
    end

    before do
      get '/users?foo=bar'
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end
end
