# frozen_string_literal: true

require 'rails_helper'

describe 'PUT /users/:id', type: :request do
  subject { response }

  let(:user) { User.create! email: 'foo@bar.com', name: 'Foo Bar' }

  context 'with valid params' do
    before do
      put "/users/#{user.id}", params: { name: 'Bar Foo' }.to_json
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(user.reload) }
  end

  context 'with email already taken' do
    let(:error) do
      {
        id: 'already_taken',
        message: 'E-mail already taken'
      }
    end

    before do
      User.create! email: 'bar@foo.com', name: 'Bar Foo'
      put "/users/#{user.id}", params: { email: 'bar@foo.com' }.to_json
    end

    it { is_expected.to have_http_status(:unprocessable_entity) }
    it { expect(response.body).to eq_json(error) }
  end
end
