# frozen_string_literal: true

require 'rails_helper'

describe 'PUT /users/:id', type: :request do
  subject { response }

  let(:user) do
    User.create! email: 'foo@bar.com', name: 'Foo Bar', password: 'foobar'
  end

  context 'with valid params' do
    before do
      put "/users/#{user.id}", params: { name: 'Bar Foo' }.to_json
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(user.reload) }
  end

  context 'with invalid param' do
    let(:params) { { email: 'foo@bar.com', name: 'Foo Bar', foo: 'bar' } }

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/user/links/2/schema: "foo" is not a permitted key.'
      }
    end

    before do
      put "/users/#{user.id}", params: params.to_json
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
          '#/definitions/user/links/2/schema: "id" is not a ' \
          'permitted key.'
      }
    end

    before do
      put "/users/#{user.id}", params: params.to_json
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
          '#/definitions/user/links/2/schema: "created_at" is not a ' \
          'permitted key.'
      }
    end

    before do
      put "/users/#{user.id}", params: params.to_json
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
          '#/definitions/user/links/2/schema: "updated_at" is not a ' \
          'permitted key.'
      }
    end

    before do
      put "/users/#{user.id}", params: params.to_json
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
      User.create! email: 'bar@foo.com', name: 'Bar Foo', password: 'barfoo'
      put "/users/#{user.id}", params: { email: 'bar@foo.com' }.to_json
    end

    it { is_expected.to have_http_status(:unprocessable_entity) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without current user' do
    let(:headers) { { 'access-token' => nil } }

    before do
      put(
        "/users/#{user.id}",
        params: { name: 'Bar Foo' }.to_json,
        headers: headers
      )
    end

    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when current user is not admin but is a supervisor' do
    before do
      current_user.update! admin: false, supervisor: true
      put "/users/#{user.id}", params: { name: 'Bar Foo' }.to_json
    end

    it { is_expected.to have_http_status(:ok) }
  end

  context 'when current user is not admin or supervisor' do
    let(:error) do
      {
        id: 'forbidden',
        message: 'not allowed to update? this User'
      }
    end

    before do
      current_user.update! admin: false, supervisor: false
      put "/users/#{user.id}", params: { name: 'Bar Foo' }.to_json
    end

    it { is_expected.to have_http_status(:forbidden) }
    it { expect(response.body).to eq_json(error) }
  end
end
