# frozen_string_literal: true

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

  def json_args(path, options = {})
    [
      path,
      {
        headers: {
          'ACCEPT' => 'application/json',
          'CONTENT_TYPE' => 'application/json'
        }
      }.deep_merge(options)
    ]
  end
end

RSpec.configure do |config|
  config.include JsonRequests, type: :request
end
