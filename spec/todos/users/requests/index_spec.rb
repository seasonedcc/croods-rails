# frozen_string_literal: true

require 'rails_helper'

describe 'GET /users', type: :request do
  subject { response }

  let(:one_organization) { Organization.create!(name: 'Foo', slug: 'foo') }
  let(:another_organization) { Organization.create!(name: 'Bar', slug: 'bar') }

  let(:one_user) do
    one_organization.users
      .create! email: 'one@another.com', name: 'Foo Bar', password: 'foobar'
  end

  let(:another_user) do
    another_organization.users
      .create! email: 'another@another.com', name: 'Bar Foo', password: 'barfoo'
  end

  before do
    one_user
    another_user
  end

  context 'with valid request' do
    before do
      get '/users'
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json([current_user]) }
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

  context 'without current user' do
    let(:headers) { { 'access-token' => nil } }

    before do
      get '/users', headers: headers
    end

    it { is_expected.to have_http_status(:ok) }
  end

  context 'when current user is not admin but is a supervisor' do
    before do
      current_user.update! admin: false, supervisor: true
      get '/users'
    end

    it { is_expected.to have_http_status(:ok) }
  end

  context 'when current user is not admin or supervisor' do
    before do
      current_user.update! admin: false, supervisor: false
      get '/users'
    end

    it { is_expected.to have_http_status(:ok) }
  end
end
