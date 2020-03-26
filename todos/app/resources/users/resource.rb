# frozen_string_literal: true

module Users
  class Resource
    include Croods::Resource

    add_param :password, :string, null: false

    extend_model do
      before_create do
        self.uid = email unless uid.present?
      end

      extend Devise::Models

      devise(
        :database_authenticatable, :registerable, :recoverable, :rememberable,
        :trackable, :validatable
      )

      include DeviseTokenAuth::Concerns::User
    end
  end
end
