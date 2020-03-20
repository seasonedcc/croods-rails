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

  context 'with invalid param' do
    let(:params) { { email: 'foo@bar.com', name: 'Foo Bar', foo: 'bar' } }

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/user/links/1/schema: "foo" is not a permitted key.'
      }
    end

    before do
      post '/users', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with id param' do
    let(:params) { { email: 'foo@bar.com', name: 'Foo Bar', id: 123 } }

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/user/links/1/schema: "id" is not a ' \
          'permitted key.'
      }
    end

    before do
      post '/users', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with created_at param' do
    let(:params) do
      {
        email: 'foo@bar.com',
        name: 'Foo Bar',
        created_at: '2018-11-13T20:20:39+00:00'
      }
    end

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/user/links/1/schema: "created_at" is not a ' \
          'permitted key.'
      }
    end

    before do
      post '/users', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with updated_at param' do
    let(:params) do
      {
        email: 'foo@bar.com',
        name: 'Foo Bar',
        updated_at: '2018-11-13T20:20:39+00:00'
      }
    end

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/user/links/1/schema: "updated_at" is not a ' \
          'permitted key.'
      }
    end

    before do
      post '/users', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without all required params' do
    let(:params) { { email: 'foo@bar.com' } }

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/user/links/1/schema: "name" wasn\'t supplied.'
      }
    end

    before do
      post '/users', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
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
