# frozen_string_literal: true

require 'rails_helper'

describe 'GET /lists', type: :request do
  subject { response }

  let(:another_organization) { Organization.create!(name: 'Bar', slug: 'bar') }

  let(:one_user) do
    current_organization.users
      .create! email: 'one@another.com', name: 'Foo Bar', password: 'foobar'
  end

  let(:another_user) do
    another_organization.users
      .create! email: 'another@another.com', name: 'Bar Foo', password: 'barfoo'
  end

  let(:one_user_project) do
    one_user.projects.create! name: 'Foo'
  end

  let(:another_user_project) do
    another_user.projects.create! name: 'Foo'
  end

  let(:project) do
    current_user.projects.create! name: 'Foo'
  end

  let(:one_user_list) do
    one_user_project.lists.create! name: 'Foo'
  end

  let(:another_user_list) do
    another_user_project.lists.create! name: 'Foo'
  end

  let(:list) do
    project.lists.create! name: 'Foo'
  end

  before do
    one_user_list
    another_user_list
    list
  end

  context 'with valid request' do
    before do
      get '/lists'
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json([one_user_list, list]) }
  end

  context 'when filtering by a project' do
    before do
      get "/lists?project_id=#{project.id}"
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json([list]) }
  end

  context 'when filtering by another project' do
    before do
      get "/lists?project_id=#{one_user_project.id}"
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json([one_user_list]) }
  end

  context 'with invalid request' do
    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/list/links/0/schema: "foo" is not a ' \
          'permitted key.'
      }
    end

    before do
      get '/lists?foo=bar'
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without current user' do
    let(:headers) { { 'access-token' => nil } }

    before do
      get '/lists', headers: headers
    end

    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when current user is not admin but is a supervisor' do
    before do
      current_user.update! admin: false, supervisor: true
      get '/lists'
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json([list]) }
  end

  context 'when current user is not admin or supervisor' do
    before do
      current_user.update! admin: false, supervisor: false
      get '/lists'
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json([list]) }
  end
end