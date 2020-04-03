# frozen_string_literal: true

require 'rails_helper'

describe 'PUT /organizations/:slug', type: :request do
  subject { response }

  let(:organization) do
    Organization.create name: 'Foo', slug: 'foo'
  end

  let(:slug) { organization.slug }

  context 'with valid params' do
    before do
      put(
        "/organizations/#{slug}", params: { name: 'Bar Foo' }.to_json
      )
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(organization.reload) }
  end

  context 'with invalid param' do
    let(:params) { { name: 'Foo', slug: 'foo', foo: 'bar' } }

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/organization/links/2/schema: "foo" is not a ' \
          'permitted key.'
      }
    end

    before do
      put "/organizations/#{slug}", params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with id param' do
    let(:params) { { name: 'Foo', slug: 'foo', id: 123 } }

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/organization/links/2/schema: "id" is not a ' \
          'permitted key.'
      }
    end

    before do
      put "/organizations/#{slug}", params: params.to_json
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
          '#/definitions/organization/links/2/schema: "created_at" is not a ' \
          'permitted key.'
      }
    end

    before do
      put "/organizations/#{slug}", params: params.to_json
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
          '#/definitions/organization/links/2/schema: "updated_at" is not a ' \
          'permitted key.'
      }
    end

    before do
      put "/organizations/#{slug}", params: params.to_json
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
      Organization.create! name: 'Bar', slug: 'bar'
      put "/organizations/#{slug}", params: { slug: 'bar' }.to_json
    end

    it { is_expected.to have_http_status(:unprocessable_entity) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without current user' do
    let(:headers) { { 'access-token' => nil } }

    before do
      put(
        "/organizations/#{slug}",
        params: { name: 'Bar Foo' }.to_json,
        headers: headers
      )
    end

    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when current user is not admin but is a supervisor' do
    let(:error) do
      {
        id: 'forbidden',
        message: 'not allowed to update? this Organization'
      }
    end

    before do
      current_user.update! admin: false, supervisor: true
      put(
        "/organizations/#{slug}", params: { name: 'Bar Foo' }.to_json
      )
    end

    it { is_expected.to have_http_status(:forbidden) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'when current user is not admin or supervisor' do
    let(:error) do
      {
        id: 'forbidden',
        message: 'not allowed to update? this Organization'
      }
    end

    before do
      current_user.update! admin: false, supervisor: false
      put(
        "/organizations/#{slug}", params: { name: 'Bar Foo' }.to_json
      )
    end

    it { is_expected.to have_http_status(:forbidden) }
    it { expect(response.body).to eq_json(error) }
  end
end
