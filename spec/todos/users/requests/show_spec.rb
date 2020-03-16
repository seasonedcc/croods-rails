# frozen_string_literal: true

require 'rails_helper'

describe 'GET /users/:id', type: :request do
  subject { response }

  let(:user) { User.create! email: 'foo@bar.com', name: 'Foo Bar' }
  let(:id) { user.id }

  before do
    get "/users/#{id}"
  end

  it { is_expected.to have_http_status(:ok) }
  it { expect(response.body).to eq_json(user) }

  context 'with record not found' do
    let(:id) { user.id + 1 }

    let(:error) do
      {
        id: 'not_found',
        message: "Couldn't find User with 'id'=#{id}"
      }
    end

    it { is_expected.to have_http_status(:not_found) }
    it { expect(response.body).to eq_json(error) }
  end
end
