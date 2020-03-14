# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: true, unique: true
      t.string :name, null: false
      t.integer :age
      t.text :bio

      t.timestamps
    end
  end
end
