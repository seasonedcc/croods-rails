# frozen_string_literal: true

require 'rails_helper'

describe 'PUT /notes/:id', type: :request do
  subject { response }

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

  let(:note) do
    list.notes.create!(text: 'foo', assignment: assignment)
  end

  before do
    project
    list
    task
    assignment
    note
  end

  context 'with optional association' do
    before do
      put "/notes/#{note.id}", params: { text: 'Bar Foo' }.to_json
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(note.reload) }
  end

  context 'without optional association' do
    let(:note) do
      list.notes.create!(text: 'foo')
    end

    before do
      put "/notes/#{note.id}", params: { text: 'Bar Foo' }.to_json
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(note.reload) }
  end

  context 'when removing the optional association' do
    before do
      put "/notes/#{note.id}", params: { assignment_id: nil }.to_json
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(note.reload) }
  end

  context 'when adding an optional association' do
    let(:note) do
      list.notes.create!(text: 'foo')
    end

    before do
      put "/notes/#{note.id}", params: { assignment_id: assignment.id }.to_json
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(note.reload) }
  end
end
