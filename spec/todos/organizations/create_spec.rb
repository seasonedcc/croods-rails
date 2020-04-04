# frozen_string_literal: true

require 'rails_helper'

describe 'POST /organizations', type: :request do
  subject { response }

  let(:params) { { name: 'Foo', slug: 'foo' } }

  context 'with valid params' do
    let(:organization) { Organization.find_by(slug: 'foo') }

    before do
      post '/organizations', params: params.to_json
    end

    it { is_expected.to have_http_status(:created) }
    it { expect(response.body).to eq_json(organization) }
  end

  context 'with invalid param' do
    let(:params) do
      { name: 'Foo', slug: 'foo', foo: 'bar' }
    end

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/organization/links/1/schema: "foo" is not a ' \
          'permitted key.'
      }
    end

    before do
      post '/organizations', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with id param' do
    let(:params) do
      { name: 'Foo', slug: 'foo', id: 123 }
    end

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/organization/links/1/schema: "id" is not a ' \
          'permitted key.'
      }
    end

    before do
      post '/organizations', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with created_at param' do
    let(:params) do
      {
        name: 'Foo',
        slug: 'foo',
        created_at: '2018-11-13T20:20:39+00:00'
      }
    end

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/organization/links/1/schema: "created_at" is not a ' \
          'permitted key.'
      }
    end

    before do
      post '/organizations', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with updated_at param' do
    let(:params) do
      {
        name: 'Foo',
        slug: 'foo',
        updated_at: '2018-11-13T20:20:39+00:00'
      }
    end

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/organization/links/1/schema: "updated_at" is not a ' \
          'permitted key.'
      }
    end

    before do
      post '/organizations', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without all required params' do
    let(:params) { { slug: 'foo' } }

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/organization/links/1/schema: "name" wasn\'t supplied.'
      }
    end

    before do
      post '/organizations', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with slug already taken' do
    let(:error) do
      {
        id: 'record_invalid',
        message: 'Validation failed: Slug has already been taken'
      }
    end

    before do
      Organization.create! name: 'Foo', slug: 'foo'
      post '/organizations', params: params.to_json
    end

    it { is_expected.to have_http_status(:unprocessable_entity) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without current user' do
    let(:headers) { { 'access-token' => nil } }

    before do
      post '/organizations', params: params.to_json, headers: headers
    end

    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when current user is not admin but is a supervisor' do
    let(:error) do
      {
        id: 'forbidden',
        message: 'not allowed to create? this Organization'
      }
    end

    before do
      current_user.update! admin: false, supervisor: true
      post '/organizations', params: params.to_json
    end

    it { is_expected.to have_http_status(:forbidden) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'when current user is not admin or supervisor' do
    let(:error) do
      {
        id: 'forbidden',
        message: 'not allowed to create? this Organization'
      }
    end

    before do
      current_user.update! admin: false, supervisor: false
      post '/organizations', params: params.to_json
    end

    it { is_expected.to have_http_status(:forbidden) }
    it { expect(response.body).to eq_json(error) }
  end
end
