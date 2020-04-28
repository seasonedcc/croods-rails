# frozen_string_literal: true

class AddBudgetToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :budget, :float
  end
end
