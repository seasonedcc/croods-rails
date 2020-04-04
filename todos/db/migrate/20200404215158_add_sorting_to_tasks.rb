# frozen_string_literal: true

class AddSortingToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :sorting, :integer
  end
end
