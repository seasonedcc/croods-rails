# frozen_string_literal: true

require 'rails_helper'

describe 'GET /organizations/:slug', type: :request do
  subject { response }

  let(:organization) do
    Organization.create name: 'Foo', slug: 'foo'
  end

  let(:slug) { organization.slug }

  context 'with valid request' do
    before do
      get "/organizations/#{slug}"
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(organization) }
  end

  context 'with invalid request' do
    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/organization/links/4/schema: "foo" is not a ' \
          'permitted key.'
      }
    end

    before do
      get "/organizations/#{slug}?foo=bar"
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with record not found' do
    let(:slug) { 'bar' }

    let(:error) do
      {
        id: 'not_found',
        message: "Couldn't find Organization"
      }
    end

    before do
      get "/organizations/#{slug}"
    end

    it { is_expected.to have_http_status(:not_found) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without current user' do
    let(:headers) { { 'access-token' => nil } }

    before do
      get "/organizations/#{slug}", headers: headers
    end

    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when current user is not admin but is a supervisor' do
    before do
      current_user.update! admin: false, supervisor: true
      get "/organizations/#{slug}"
    end

    it { is_expected.to have_http_status(:forbidden) }
  end

  context 'when current user is not admin or supervisor' do
    before do
      current_user.update! admin: false, supervisor: false
      get "/organizations/#{slug}"
    end

    it { is_expected.to have_http_status(:forbidden) }
  end
end
