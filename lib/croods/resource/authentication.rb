# frozen_string_literal: true

module Croods
  module Resource
    module Authentication
      OPTIONS = %i[
        database_authenticatable registerable recoverable rememberable
        trackable validatable
      ].freeze

      ATTRIBUTES = %i[
        allow_password_change confirmation_sent_at confirmation_token
        encrypted_password confirmed_at provider uid remember_created_at
        reset_password_sent_at reset_password_token tokens unconfirmed_email
      ].freeze

      def use_for_authentication!(*options)
        add_model_authentication(*options)

        remove_attributes(*ATTRIBUTES)

        if Croods.multi_tenancy?
          remove_attribute "#{Croods.multi_tenancy_by}_id"
        end

        request do
          add_attribute :password, :string, null: false
        end
      end

      def add_model_authentication(*options)
        extend_model do
          before_create do
            self.uid = email unless uid.present?
          end

          extend Devise::Models

          devise_options = options.empty? ? OPTIONS : options
          devise(*devise_options)

          include DeviseTokenAuth::Concerns::User
        end
      end
    end
  end
end
