# frozen_string_literal: true

require 'rails_helper'

describe 'DELETE /users/:id', type: :request do
  subject { response }

  let(:user) do
    User.create! email: 'foo@bar.com', name: 'Foo Bar', password: 'foobar'
  end

  context 'with valid request' do
    before do
      delete "/users/#{user.id}"
    end

    it { is_expected.to have_http_status(:ok) }
    it { expect(response.body).to eq_json(user) }
    it { expect(User.count).to eq(0) }
  end

  context 'with invalid request' do
    let(:error) do
      {
        id: 'bad_request',
        message: "Invalid request.\n\n#: failed schema " \
          '#/definitions/user/links/3/schema: "foo" is not a ' \
          'permitted key.'
      }
    end

    before do
      delete "/users/#{user.id}", params: { foo: 'bar' }.to_json
    end

    it { is_expected.to have_http_status(:bad_request) }
    it { expect(response.body).to eq_json(error) }
    it { expect(User.count).to eq(1) }
  end
end
