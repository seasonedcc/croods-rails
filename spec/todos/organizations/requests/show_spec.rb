# frozen_string_literal: true

require 'rails_helper'

describe 'GET /organizations/:id', type: :request do
  subject { response }

  let(:organization) do
    Organization.create name: 'Foo', slug: 'foo'
  end

  let(:id) { organization.id }

  context 'with valid request' do
    before do
      get "/organizations/#{id}"
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
      get "/organizations/#{id}?foo=bar"
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with record not found' do
    let(:id) { organization.id + 1 }

    let(:error) do
      {
        id: 'not_found',
        message: "Couldn't find Organization with 'id'=#{id}"
      }
    end

    before do
      get "/organizations/#{id}"
    end

    it { is_expected.to have_http_status(:not_found) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without current user' do
    let(:headers) { { 'access-token' => nil } }

    before do
      get "/organizations/#{id}", headers: headers
    end

    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when current user is not admin but is a supervisor' do
    before do
      current_user.update! admin: false, supervisor: true
      get "/organizations/#{id}"
    end

    it { is_expected.to have_http_status(:forbidden) }
  end

  context 'when current user is not admin or supervisor' do
    before do
      current_user.update! admin: false, supervisor: false
      get "/organizations/#{id}"
    end

    it { is_expected.to have_http_status(:forbidden) }
  end
end