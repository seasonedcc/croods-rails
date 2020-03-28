# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
