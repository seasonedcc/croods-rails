# frozen_string_literal: true

class AddFinishedToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :finished, :boolean, null: false, default: false
  end
end
