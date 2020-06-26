class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.references :assignment
      t.references :list, null: false
      t.text :text, null: false

      t.timestamps
    end
  end
end
