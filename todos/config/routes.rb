# frozen_string_literal: true

Rails.application.routes.draw do
  mount_croods
  # mount_devise_token_auth_for 'User', at: 'auth'
end
