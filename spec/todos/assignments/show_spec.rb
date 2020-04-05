# frozen_string_literal: true

require 'rails_helper'

describe 'GET /assignments/:id', type: :request do
  it do
    expect { get('/assignments/123') }
      .to raise_error(ActionController::RoutingError)
  end
end
