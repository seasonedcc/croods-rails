# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.references :user, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
