# frozen_string_literal: true

require 'rails_helper'

describe 'GET /assignments', type: :request do
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

  let(:third_user) do
    current_organization.users
      .create! email: 'third@another.com', name: 'Foo Bar', password: 'foobar'
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

  let(:assignments) do
    task.assignments.order(:created_at)
  end

  before do
    task.assignments.create! user: one_user
    task.assignments.create! user: current_user
    task.assignments.create! user: third_user
    one_user_task.assignments.create! user: one_user
    one_user_task.assignments.create! user: current_user
    another_user_task.assignments.create! user: another_user
  end

  context 'with valid request' do
    before do
      get "/assignments?task_id=#{task.id}"
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(assignments) }
  end

  context 'with invalid request' do
    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/assignment/links/0/schema: "foo" is not a ' \
          'permitted key.'
      }
    end

    before do
      get "/assignments?task_id=#{task.id}&foo=bar"
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without current user' do
    let(:headers) { { 'access-token' => nil } }

    before do
      get "/assignments?task_id=#{task.id}", headers: headers
    end

    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when current user is not admin but is a supervisor' do
    before do
      current_user.update! admin: false, supervisor: true
      get "/assignments?task_id=#{task.id}"
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(assignments) }
  end

  context 'when current user is not admin or supervisor' do
    before do
      current_user.update! admin: false, supervisor: false
      get "/assignments?task_id=#{task.id}"
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(assignments) }
  end

  context 'when task is from another organization' do
    before do
      current_user.update! admin: false
      get "/assignments?task_id=#{another_user_task.id}"
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json([]) }
  end

  context 'when task is from another user from the same organization' do
    before do
      current_user.update! admin: false
      get "/assignments?task_id=#{one_user_task.id}"
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json([]) }
  end
end
