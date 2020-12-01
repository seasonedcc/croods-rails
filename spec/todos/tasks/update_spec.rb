# frozen_string_literal: true

require 'rails_helper'

describe 'PUT /tasks/:id', type: :request do
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

  let(:one_user_task) do
    one_user_list.tasks.create! name: 'Foo'
  end

  let(:another_user_task) do
    another_user_list.tasks.create! name: 'Foo'
  end

  let(:task) do
    list.tasks.create! name: 'Foo'
  end

  before do
    one_user_task
    another_user_task
    task
  end

  context 'with valid params' do
    let(:status_text) { 'Current User just updated a task.' }

    before do
      put "/tasks/#{task.id}", params: { name: 'Bar Foo' }.to_json
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(task.reload) }
    it { expect(list.reload.status_text).to eq(status_text) }
  end

  context 'with invalid param' do
    let(:params) { { name: 'Foo', foo: 'bar' } }

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/task/links/3/schema: "foo" is not a permitted key.'
      }
    end

    before do
      put "/tasks/#{task.id}", params: params.to_json
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
          '#/definitions/task/links/3/schema: "id" is not a ' \
          'permitted key.'
      }
    end

    before do
      put "/tasks/#{task.id}", params: params.to_json
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
          '#/definitions/task/links/3/schema: "created_at" is not a ' \
          'permitted key.'
      }
    end

    before do
      put "/tasks/#{task.id}", params: params.to_json
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
          '#/definitions/task/links/3/schema: "updated_at" is not a ' \
          'permitted key.'
      }
    end

    before do
      put "/tasks/#{task.id}", params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with finished param' do
    let(:params) { { name: 'Foo', finished: true } }

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/task/links/3/schema: "finished" is not a ' \
          'permitted key.'
      }
    end

    before do
      put "/tasks/#{task.id}", params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with record not found' do
    let(:id) { task.id + 1 }

    let(:error) do
      {
        id: 'not_found',
        message: "Couldn't find Task with 'id'=#{id} " \
           '[WHERE "users"."organization_id" = $1]'
      }
    end

    before do
      put "/tasks/#{id}", params: { name: 'Bar Foo' }.to_json
    end

    it { is_expected.to have_http_status(:not_found) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without current user' do
    let(:headers) { { 'access-token' => nil } }

    before do
      put(
        "/tasks/#{task.id}",
        params: { name: 'Bar Foo' }.to_json,
        headers: headers
      )
    end

    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when current user is not admin but is a supervisor' do
    before do
      current_user.update! admin: false, supervisor: true
      put "/tasks/#{task.id}", params: { name: 'Bar Foo' }.to_json
    end

    it { is_expected.to have_http_status(:ok) }
  end

  context 'when current user is not admin or supervisor' do
    before do
      current_user.update! admin: false, supervisor: false
      put "/tasks/#{task.id}", params: { name: 'Bar Foo' }.to_json
    end

    it { is_expected.to have_http_status(:ok) }
  end

  context 'when we add an attribute that does not exist in the model' do
    let(:params) { { foobaz: 'foobar' } }

    before do
      put "/tasks/#{task.id}", params: params.to_json
    end

    it { is_expected.to have_http_status(:ok) }
    # it { expect(response.body).to eq_json(error) }
  end

  context 'when task is from another organization' do
    let(:id) { another_user_task.id }

    let(:error) do
      {
        id: 'not_found',
        message: "Couldn't find Task with 'id'=#{id} " \
           '[WHERE "users"."organization_id" = $1]'
      }
    end

    before do
      put "/tasks/#{id}", params: { name: 'Bar Foo' }.to_json
    end

    it { is_expected.to have_http_status(:not_found) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'when task is from another user in the same organization' do
    let(:id) { one_user_task.id }

    let(:error) do
      {
        id: 'not_found',
        message: "Couldn't find Task with 'id'=#{id} " \
          '[WHERE "users"."organization_id" = $1 AND "projects"."user_id" = $2]'
      }
    end

    before do
      current_user.update! admin: false
      put "/tasks/#{id}", params: { name: 'Bar Foo' }.to_json
    end

    it { is_expected.to have_http_status(:not_found) }
    it { expect(response.body).to eq_json(error) }
  end
end
