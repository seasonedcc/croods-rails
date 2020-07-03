# frozen_string_literal: true

require 'rails_helper'

describe 'DELETE /notes/:id', type: :request do
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
    list.notes.create!(text: 'foo')
  end

  before do
    project
    list
    task
    assignment
    note
  end

  context 'without the optional association' do
    before do
      delete "/notes/#{note.id}"
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(note) }
    it { expect(list.notes.find_by(text: 'foo')).to be_nil }
  end

  context 'with the optional association' do
    let(:note) do
      list.notes.create!(text: 'foo', assignment: assignment)
    end

    before do
      delete "/notes/#{note.id}"
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(note) }
    it { expect(list.notes.find_by(text: 'foo')).to be_nil }
  end
end
