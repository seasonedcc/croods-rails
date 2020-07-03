# frozen_string_literal: true

require 'rails_helper'

describe 'GET /notes', type: :request do
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

  let(:notes) do
    list.notes.order(:created_at)
  end

  context 'with valid request' do
    before do
      get "/notes?list_id=#{list.id}"
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(notes) }
  end

  context 'without the optional association' do
    before do
      note.update!(assignment: nil)

      get "/notes?list_id=#{list.id}"
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(notes) }
  end
end
