# frozen_string_literal: true

require 'rails_helper'

describe 'POST /tasks', type: :request do
  subject { response }

  let(:params) { { name: 'Foo Bar', list_id: list.id } }

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

  context 'with valid params' do
    let(:task) { Task.find_by(name: 'Foo Bar') }
    let(:reloaded_list) { list.reload }
    let(:status_text) { 'Current User just created a task.' }

    before do
      post '/tasks', params: params.to_json
    end

    it { is_expected.to have_http_status(:created) }
    it { expect(response.body).to eq_json(task) }
    it { expect(reloaded_list.total_tasks).to eq(1) }
    it { expect(reloaded_list.status_text).to eq(status_text) }
  end

  context 'with invalid param' do
    let(:params) do
      { name: 'Foo Bar', list_id: list.id, foo: 'bar' }
    end

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/task/links/2/schema: "foo" is not a permitted key.'
      }
    end

    before do
      post '/tasks', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with id param' do
    let(:params) do
      { name: 'Foo Bar', list_id: list.id, id: 123 }
    end

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/task/links/2/schema: "id" is not a ' \
          'permitted key.'
      }
    end

    before do
      post '/tasks', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with created_at param' do
    let(:params) do
      {
        name: 'Foo Bar',
        list_id: list.id,
        created_at: '2018-11-13T20:20:39+00:00'
      }
    end

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/task/links/2/schema: "created_at" is not a ' \
          'permitted key.'
      }
    end

    before do
      post '/tasks', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with updated_at param' do
    let(:params) do
      {
        name: 'Foo Bar',
        list_id: list.id,
        updated_at: '2018-11-13T20:20:39+00:00'
      }
    end

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/task/links/2/schema: "updated_at" is not a ' \
          'permitted key.'
      }
    end

    before do
      post '/tasks', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with finished param' do
    let(:params) do
      { name: 'Foo Bar', list_id: list.id, finished: true }
    end

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/task/links/2/schema: "finished" is not a ' \
          'permitted key.'
      }
    end

    before do
      post '/tasks', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without all required params' do
    let(:params) { { list_id: list.id } }

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/task/links/2/schema: "name" wasn\'t supplied.'
      }
    end

    before do
      post '/tasks', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without current user' do
    let(:headers) { { 'access-token' => nil } }

    before do
      post '/tasks', params: params.to_json, headers: headers
    end

    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when current user is not admin but is a supervisor' do
    before do
      current_user.update! admin: false, supervisor: true
      post '/tasks', params: params.to_json
    end

    it { is_expected.to have_http_status(:created) }
  end

  context 'when current user is not admin or supervisor' do
    before do
      current_user.update! admin: false, supervisor: false
      post '/tasks', params: params.to_json
    end

    it { is_expected.to have_http_status(:created) }
  end

  context 'with a project from another organization' do
    let(:params) { { name: 'Foo Bar', list_id: another_user_list.id } }

    let(:task) { Task.find_by(name: 'Foo Bar') }

    let(:error) do
      {
        id: 'forbidden',
        message: 'not allowed to create? this Task'
      }
    end

    before do
      post '/tasks', params: params.to_json
    end

    it { is_expected.to have_http_status(:forbidden) }
    it { expect(task).to be_nil }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with a project from another user' do
    let(:params) { { name: 'Foo Bar', list_id: one_user_list.id } }

    let(:task) { Task.find_by(name: 'Foo Bar') }

    let(:error) do
      {
        id: 'forbidden',
        message: 'not allowed to create? this Task'
      }
    end

    before do
      current_user.update! admin: false
      post '/tasks', params: params.to_json
    end

    it { is_expected.to have_http_status(:forbidden) }
    it { expect(task).to be_nil }
    it { expect(response.body).to eq_json(error) }
  end
end
