# frozen_string_literal: true

class AddSupervisorToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :supervisor, :boolean, null: false, default: false
  end
end
