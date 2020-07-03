# frozen_string_literal: true

require 'rails_helper'

describe 'POST /notes', type: :request do
  subject { response }

  let(:params) { { text: 'Foo Bar', list_id: list.id } }

  let(:project) do
    current_user.projects.create! name: 'Foo'
  end

  let(:list) do
    project.lists.create! name: 'Foo'
  end

  let(:task) do
    list.tasks.create! name: 'Foo'
  end

  let(:assignment) do
    task.assignments.create! user: current_user
  end

  let(:note) { Note.find_by(text: 'Foo Bar') }
  
  context 'without the optional association' do
    before do
      post '/notes', params: params.to_json
    end

    it { is_expected.to have_http_status(:created) }
    it { expect(response.body).to eq_json(note) }
  end

  context 'with the optional association' do
    let(:params) do
      { text: 'Foo Bar', list_id: list.id, assignment_id: assignment.id }
    end

    before do
      post '/notes', params: params.to_json
    end

    it { is_expected.to have_http_status(:created) }
    it { expect(response.body).to eq_json(note) }
  end

  context 'without the required association' do
    let(:params) do
      { text: 'Foo Bar', assignment_id: assignment.id }
    end

    before do
      post '/notes', params: params.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to include('list_id', "wasn't supplied.") }
  end
end
