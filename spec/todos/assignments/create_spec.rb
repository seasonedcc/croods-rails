# frozen_string_literal: true

require 'rails_helper'

describe 'POST /assignments', type: :request do
  subject { response }

  let(:params) { { user_id: one_user.id, task_id: task.id } }

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

  context 'with valid params' do
    let(:assignment) { Assignment.find_by(user: one_user, task: task) }

    before do
      post '/assignments', params: params.to_json
    end

    it { is_expected.to have_http_status(:created) }
    it { expect(response.body).to eq_json(assignment) }
  end

  context 'with invalid param' do
    let(:params) do
      { user_id: one_user.id, task_id: task.id, foo: 'bar' }
    end

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/assignment/links/1/schema: "foo" is not a permitted' \
          ' key.'
      }
    end

    before do
      post '/assignments', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with id param' do
    let(:params) do
      { user_id: one_user.id, task_id: task.id, id: 123 }
    end

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/assignment/links/1/schema: "id" is not a ' \
          'permitted key.'
      }
    end

    before do
      post '/assignments', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with created_at param' do
    let(:params) do
      {
        user_id: one_user.id,
        task_id: task.id,
        created_at: '2018-11-13T20:20:39+00:00'
      }
    end

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/assignment/links/1/schema: "created_at" is not a ' \
          'permitted key.'
      }
    end

    before do
      post '/assignments', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with updated_at param' do
    let(:params) do
      {
        user_id: one_user.id,
        task_id: task.id,
        updated_at: '2018-11-13T20:20:39+00:00'
      }
    end

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/assignment/links/1/schema: "updated_at" is not a ' \
          'permitted key.'
      }
    end

    before do
      post '/assignments', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without all required params' do
    let(:params) { { task_id: task.id } }

    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/assignment/links/1/schema: "user_id" wasn\'t supplied.'
      }
    end

    before do
      post '/assignments', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without current user' do
    let(:headers) { { 'access-token' => nil } }

    before do
      post '/assignments', params: params.to_json, headers: headers
    end

    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when current user is not admin but is a supervisor' do
    let(:assignment) { Assignment.find_by(user: one_user, task: task) }

    before do
      current_user.update! admin: false, supervisor: true
      post '/assignments', params: params.to_json
    end

    it { is_expected.to have_http_status(:created) }
    it { expect(response.body).to eq_json(assignment) }
  end

  context 'when current user is not admin or supervisor' do
    let(:assignment) { Assignment.find_by(user: one_user, task: task) }

    before do
      current_user.update! admin: false, supervisor: false
      post '/assignments', params: params.to_json
    end

    it { is_expected.to have_http_status(:created) }
    it { expect(response.body).to eq_json(assignment) }
  end

  context 'when assigning a task to yourself without being admin' do
    let(:params) { { user_id: current_user.id, task_id: task.id } }
    let(:assignment) { Assignment.find_by(user: current_user, task: task) }

    before do
      current_user.update! admin: false
      post '/assignments', params: params.to_json
    end

    it { is_expected.to have_http_status(:created) }
    it { expect(response.body).to eq_json(assignment) }
  end

  context 'with a task from another organization' do
    let(:params) { { user_id: one_user.id, task_id: another_user_task.id } }

    let(:error) do
      {
        id: 'forbidden',
        message: 'not allowed to create? this Assignment'
      }
    end

    before do
      post '/assignments', params: params.to_json
    end

    it { is_expected.to have_http_status(:forbidden) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with a user from another organization' do
    let(:params) { { user_id: another_user.id, task_id: task.id } }

    let(:error) do
      {
        id: 'forbidden',
        message: 'not allowed to create? this Assignment'
      }
    end

    before do
      post '/assignments', params: params.to_json
    end

    it { is_expected.to have_http_status(:forbidden) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'with a task from another user' do
    let(:params) { { user_id: one_user.id, task_id: one_user_task.id } }

    let(:error) do
      {
        id: 'forbidden',
        message: 'not allowed to create? this Assignment'
      }
    end

    before do
      current_user.update! admin: false
      post '/assignments', params: params.to_json
    end

    it { is_expected.to have_http_status(:forbidden) }
    it { expect(response.body).to eq_json(error) }
  end
end
