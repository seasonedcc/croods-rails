# frozen_string_literal: true

class AddStatsToLists < ActiveRecord::Migration[5.2]
  def change
    add_column :lists, :total_tasks, :integer, null: false, default: 0
    add_column :lists, :finished_tasks, :integer, null: false, default: 0
    add_column :lists, :progress, :integer, null: false, default: 0
    add_column :lists, :status_text, :string
  end
end
