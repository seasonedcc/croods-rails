# frozen_string_literal: true

require 'rails_helper'

describe 'DELETE /assignments/:id', type: :request do
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

  let(:one_user_assignment) do
    one_user_task.assignments.create! user: one_user
  end

  let(:another_user_assignment) do
    another_user_task.assignments.create! user: one_user
  end

  let(:assignment) do
    task.assignments.create! user: one_user
  end

  before do
    one_user_assignment
    another_user_assignment
    assignment
  end

  context 'with valid request' do
    before do
      delete "/assignments/#{assignment.id}"
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(assignment) }
    it { expect(task.assignments.find_by(user: current_user)).to be_nil }
  end

  context 'with invalid request' do
    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/assignment/links/3/schema: "foo" is not a ' \
          'permitted key.'
      }
    end

    before do
      delete "/assignments/#{assignment.id}", params: { foo: 'bar' }.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }

    it { expect(task.assignments.find_by(user: one_user)).to eq(assignment) }
  end

  context 'with record not found' do
    let(:id) { assignment.id + 1 }

    let(:error) do
      {
        id: 'not_found',
        message: "Couldn't find Assignment with 'id'=#{id} " \
          '[WHERE "users"."organization_id" = $1]'
      }
    end

    before do
      delete "/assignments/#{id}"
    end

    it { is_expected.to have_http_status(:not_found) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'without current user' do
    let(:headers) { { 'access-token' => nil } }

    before do
      delete "/assignments/#{assignment.id}", headers: headers
    end

    it { is_expected.to have_http_status(:unauthorized) }
  end

  context 'when current user is not admin but is a supervisor' do
    before do
      current_user.update! admin: false, supervisor: true
      delete "/assignments/#{assignment.id}"
    end

    it { is_expected.to have_http_status(:ok) }
  end

  context 'when current user is not admin or supervisor' do
    before do
      current_user.update! admin: false, supervisor: false
      delete "/assignments/#{assignment.id}"
    end

    it { is_expected.to have_http_status(:ok) }
  end

  context 'when assignment is from another organization' do
    let(:id) { another_user_assignment.id }

    let(:error) do
      {
        id: 'not_found',
        message: "Couldn't find Assignment with 'id'=#{id} " \
           '[WHERE "users"."organization_id" = $1]'
      }
    end

    before do
      delete "/assignments/#{id}"
    end

    it { is_expected.to have_http_status(:not_found) }
    it { expect(response.body).to eq_json(error) }
  end

  context 'when task is from another user from the same organization' do
    let(:id) { one_user_assignment.id }

    let(:error) do
      {
        id: 'not_found',
        message: "Couldn't find Assignment with 'id'=#{id} " \
          '[WHERE "users"."organization_id" = $1 AND "projects"."user_id" = $2]'
      }
    end

    before do
      current_user.update! admin: false
      delete "/assignments/#{id}"
    end

    it { is_expected.to have_http_status(:not_found) }
    it { expect(response.body).to eq_json(error) }
  end
end
