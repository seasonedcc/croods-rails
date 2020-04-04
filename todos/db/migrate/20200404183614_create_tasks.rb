# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.references :list, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
