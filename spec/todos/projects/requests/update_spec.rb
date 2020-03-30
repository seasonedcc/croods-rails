# frozen_string_literal: true

require 'rails_helper'

describe 'PUT /projects/:id', type: :request do
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

  context 'with valid params' do
    before do
      put "/projects/#{project.id}", params: { name: 'Bar Foo' }.to_json
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(project.reload) }
  end

  context 'with invalid param' do
    let(:params) { { name: 'Foo', foo: 'bar' } }

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/project/links/2/schema: "foo" is not a permitted key.'
      }
    end

    before do
      put "/projects/#{project.id}", params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with id param' do
    let(:params) { { name: 'Foo', id: 123 } }

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/project/links/2/schema: "id" is not a ' \
          'permitted key.'
      }
    end

    before do
      put "/projects/#{project.id}", params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with created_at param' do
    let(:params) do
      {
        name: 'Foo Bar',
        created_at: '2018-11-13T20:20:39+00:00'
      }
    end

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/project/links/2/schema: "created_at" is not a ' \
          'permitted key.'
      }
    end

    before do
      put "/projects/#{project.id}", params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with updated_at param' do
    let(:params) do
      {
        name: 'Foo Bar',
        updated_at: '2018-11-13T20:20:39+00:00'
      }
    end

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/project/links/2/schema: "updated_at" is not a ' \
          'permitted key.'
      }
    end

    before do
      put "/projects/#{project.id}", params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
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
      put "/projects/#{id}", params: { name: 'Bar Foo' }.to_json
    end

    it { is_expected.to have_http_status(:not_found) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without current user' do
    let(:headers) { { 'access-token' => nil } }

    before do
      put(
        "/projects/#{project.id}",
        params: { name: 'Bar Foo' }.to_json,
        headers: headers
      )
    end

    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when current user is not admin but is a supervisor' do
    before do
      current_user.update! admin: false, supervisor: true
      put "/projects/#{project.id}", params: { name: 'Bar Foo' }.to_json
    end

    it { is_expected.to have_http_status(:ok) }
  end

  context 'when current user is not admin or supervisor' do
    before do
      current_user.update! admin: false, supervisor: false
      put "/projects/#{project.id}", params: { name: 'Bar Foo' }.to_json
    end

    it { is_expected.to have_http_status(:ok) }
  end

  context 'when user is from another organization' do
    let(:id) { another_user_project.id }

    let(:error) do
      {
        id: 'not_found',
        message: "Couldn't find Project with 'id'=#{id} " \
           '[WHERE "users"."organization_id" = $1]'
      }
    end

    before do
      put "/projects/#{id}", params: { name: 'Bar Foo' }.to_json
    end

    it { is_expected.to have_http_status(:not_found) }
    it { expect(response.body).to eq_json(error) }
  end
end
