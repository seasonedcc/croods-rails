# frozen_string_literal: true

require 'rails_helper'

describe 'PUT /assignments/:id', type: :request do
  it do
    expect { put('/assignments/123') }
      .to raise_error(ActionController::RoutingError)
  end
end
