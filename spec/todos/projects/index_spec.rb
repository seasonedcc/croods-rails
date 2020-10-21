# frozen_string_literal: true

require 'rails_helper'

describe 'GET /projects', type: :request do
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
    another_user.projects.create! name: 'Bar'
  end

  let(:project) do
    current_user.projects.create! name: 'Baz'
  end

  before do
    one_user_project
    another_user_project
    project
  end

  context 'with valid request' do
    before do
      get '/projects'
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json([one_user_project, project]) }
  end

  context 'with invalid request' do
    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/project/links/1/schema: "foo" is not a ' \
          'permitted key.'
      }
    end

    before do
      get '/projects?foo=bar'
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without current user' do
    let(:headers) { { 'access-token' => nil } }

    before do
      get '/projects', headers: headers
    end

    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when current user is not admin but is a supervisor' do
    before do
      current_user.update! admin: false, supervisor: true
      get '/projects'
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json([project]) }
  end

  context 'when current user is not admin or supervisor' do
    before do
      current_user.update! admin: false, supervisor: false
      get '/projects'
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json([project]) }
  end

  context 'with pagination' do
    before do
      create_user_projects
      current_user.update! admin: false, supervisor: false
    end

    context 'when page is unspecified' do
      before do
        get '/projects'
      end

      it { is_expected.to have_http_status(:ok) }
      it { expect(JSON.parse(response.body).length).to eq(30) }
      it { expect(response.headers['Total']).to be nil }
      it { expect(response.headers['Per-Page']).to be nil }
    end

    context 'when first page' do
      before do
        get '/projects?page=1'
      end

      it { is_expected.to have_http_status(:ok) }
      it { expect(JSON.parse(response.body).length).to eq(25) }
      it { expect(response.headers['Total']).to eq('30') }
      it { expect(response.headers['Per-Page']).to eq('25') }
    end

    context 'when second page' do
      before do
        get '/projects?page=2'
      end

      it { is_expected.to have_http_status(:ok) }
      it { expect(JSON.parse(response.body).length).to eq(5) }
      it { expect(response.headers['Total']).to eq('30') }
      it { expect(response.headers['Per-Page']).to eq('25') }
    end

    context 'with custom per_page' do
      before do
        get '/projects?page=1&per_page=10'
      end

      it { is_expected.to have_http_status(:ok) }
      it { expect(JSON.parse(response.body).length).to eq(10) }
      it { expect(response.headers['Total']).to eq('30') }
      it { expect(response.headers['Per-Page']).to eq('10') }
    end

    context 'with page out of range' do
      before do
        get '/projects?page=5'
      end

      it { is_expected.to have_http_status(:ok) }
      it { expect(JSON.parse(response.body).length).to eq(0) }
      it { expect(response.headers['Total']).to eq('30') }
      it { expect(response.headers['Per-Page']).to eq('25') }
    end
  end

  context 'when searching by name' do
    before do
      project.update! deadline: '2020-10-05'
      get '/projects?query=baz'
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json([project]) }
  end

  private

  def create_user_projects
    29.times do
      current_user.projects.create! name: 'Foo'
    end
  end
end
