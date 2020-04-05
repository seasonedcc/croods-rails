# frozen_string_literal: true

class CreateAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :assignments do |t|
      t.references :task, null: false
      t.references :user, null: false

      t.timestamps
    end
  end
end
