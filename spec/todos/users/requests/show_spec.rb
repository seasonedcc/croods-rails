# frozen_string_literal: true

require 'rails_helper'

describe 'GET /users/:id', type: :request do
  subject { response }

  let(:user) do
    User.create! email: 'foo@bar.com', name: 'Foo Bar', password: 'foobar'
  end

  let(:id) { user.id }

  context 'with valid request' do
    before do
      get "/users/#{id}"
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(user) }
  end

  context 'with invalid request' do
    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/user/links/4/schema: "foo" is not a ' \
          'permitted key.'
      }
    end

    before do
      get "/users/#{id}?foo=bar"
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with record not found' do
    let(:id) { user.id + 1 }

    let(:error) do
      {
        id: 'not_found',
        message: "Couldn't find User with 'id'=#{id}"
      }
    end

    before do
      get "/users/#{id}"
    end

    it { is_expected.to have_http_status(:not_found) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without current user' do
    let(:headers) { { 'access-token' => nil } }

    before do
      get "/users/#{id}", headers: headers
    end

    it { is_expected.to have_http_status(:unauthorized) }
  end
end
