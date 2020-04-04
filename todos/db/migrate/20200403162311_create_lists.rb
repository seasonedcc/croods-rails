# frozen_string_literal: true

class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.references :project, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
