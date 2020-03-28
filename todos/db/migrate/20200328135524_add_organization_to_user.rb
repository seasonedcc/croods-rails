# frozen_string_literal: true

class AddOrganizationToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :organization, null: false
  end
end
