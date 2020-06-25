# frozen_string_literal: true

class AddFilesToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :files, :jsonb, default: []
  end
end
