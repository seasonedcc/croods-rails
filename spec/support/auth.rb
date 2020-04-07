# frozen_string_literal: true

RSpec.shared_context 'with current_user' do
  let(:current_organization) do
    Organization.create!(
      name: 'Current Organization', slug: 'current-organization'
    )
  end

  let!(:current_user) do
    current_organization.users.create!(
      email: 'current.user@email.com',
      name: 'Current User',
      password: 'foobar',
      admin: true,
      supervisor: true
    )
  end
end

RSpec.configure do |config|
  config.include_context 'with current_user'
end

module JsonRequests
  def get(*args)
    super(*json_args(*args))
  end

  def post(*args)
    super(*json_args(*args))
  end

  def update(*args)
    super(*json_args(*args))
  end

  def patch(*args)
    super(*json_args(*args))
  end

  def put(*args)
    super(*json_args(*args))
  end

  def delete(*args)
    super(*json_args(*args))
  end

  def base_headers
    {
      'ACCEPT' => 'application/json',
      'CONTENT_TYPE' => 'application/json',
      'Tenant' => current_organization.slug
    }
  end

  def json_args(path, **options)
    auth_headers = current_user.create_new_auth_token
    [
      path,
      {
        headers: auth_headers.merge(base_headers)
      }.deep_merge(options)
    ]
  end
end

RSpec.configure do |config|
  config.include JsonRequests, type: :request
end
