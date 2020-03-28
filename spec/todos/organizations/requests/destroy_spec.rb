# frozen_string_literal: true

require 'rails_helper'

describe 'DELETE /organizations/:id', type: :request do
  subject { response }

  let(:organization) do
    Organization.create name: 'Foo', slug: 'foo'
  end

  context 'with valid request' do
    before do
      delete "/organizations/#{organization.id}"
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(organization) }
    it { expect(Organization.find_by(slug: 'foo')).to be_nil }
  end

  context 'with invalid request' do
    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/organization/links/3/schema: "foo" is not a ' \
          'permitted key.'
      }
    end

    before do
      delete "/organizations/#{organization.id}", params: { foo: 'bar' }.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
    it { expect(Organization.find_by(slug: 'foo')).to eq(organization) }
  end

  context 'without current user' do
    let(:headers) { { 'access-token' => nil } }

    before do
      delete "/organizations/#{organization.id}", headers: headers
    end

    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when current user is not admin but is a supervisor' do
    let(:error) do
      {
        id: 'forbidden',
        message: 'not allowed to destroy? this Organization'
      }
    end

    before do
      current_user.update! admin: false, supervisor: true
      delete "/organizations/#{organization.id}"
    end

    it { is_expected.to have_http_status(:forbidden) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'when current user is not admin or supervisor' do
    let(:error) do
      {
        id: 'forbidden',
        message: 'not allowed to destroy? this Organization'
      }
    end

    before do
      current_user.update! admin: false, supervisor: false
      delete "/organizations/#{organization.id}"
    end

    it { is_expected.to have_http_status(:forbidden) }
    it { expect(response.body).to eq_json(error) }
  end
end
