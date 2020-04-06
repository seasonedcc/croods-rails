# frozen_string_literal: true

require 'rails_helper'

describe 'DELETE /projects/:id', type: :request do
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

  before do
    one_user_project
    another_user_project
    project
  end

  context 'with valid request' do
    before do
      delete "/projects/#{project.id}"
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(project) }
    it { expect(current_user.projects.find_by(name: 'Foo')).to be_nil }
  end

  context 'with invalid request' do
    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/project/links/4/schema: "foo" is not a ' \
          'permitted key.'
      }
    end

    before do
      delete "/projects/#{project.id}", params: { foo: 'bar' }.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
    it { expect(current_user.projects.find_by(name: 'Foo')).to eq(project) }
  end

  context 'with record not found' do
    let(:id) { project.id + 1 }

    let(:error) do
      {
        id: 'not_found',
        message: "Couldn't find Project with 'id'=#{id} " \
           '[WHERE "users"."organization_id" = $1]'
      }
    end

    before do
      delete "/projects/#{id}"
    end

    it { is_expected.to have_http_status(:not_found) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without current user' do
    let(:headers) { { 'access-token' => nil } }

    before do
      delete "/projects/#{project.id}", headers: headers
    end

    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when current user is not admin but is a supervisor' do
    before do
      current_user.update! admin: false, supervisor: true
      delete "/projects/#{project.id}"
    end

    it { is_expected.to have_http_status(:ok) }
  end

  context 'when current user is not admin or supervisor' do
    before do
      current_user.update! admin: false, supervisor: false
      delete "/projects/#{project.id}"
    end

    it { is_expected.to have_http_status(:ok) }
  end

  context 'when project is from another organization' do
    let(:id) { another_user_project.id }

    let(:error) do
      {
        id: 'not_found',
        message: "Couldn't find Project with 'id'=#{id} " \
           '[WHERE "users"."organization_id" = $1]'
      }
    end

    before do
      delete "/projects/#{id}"
    end

    it { is_expected.to have_http_status(:not_found) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'when project is from another user from the same organization' do
    let(:id) { one_user_project.id }

    let(:error) do
      {
        id: 'not_found',
        message: "Couldn't find Project with 'id'=#{id} " \
          '[WHERE "users"."organization_id" = $1 AND "projects"."user_id" = $2]'
      }
    end

    before do
      current_user.update! admin: false
      delete "/projects/#{id}"
    end

    it { is_expected.to have_http_status(:not_found) }
    it { expect(response.body).to eq_json(error) }
  end
end
