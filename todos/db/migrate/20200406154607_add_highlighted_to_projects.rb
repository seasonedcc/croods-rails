# frozen_string_literal: true

class AddHighlightedToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :highlighted, :boolean, null: false, default: false
  end
end
