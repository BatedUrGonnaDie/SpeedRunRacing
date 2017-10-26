class CreateRaces < ActiveRecord::Migration[5.0]
  def change
    create_table :races do |t|
      t.boolean :archived, null: false, default: false
      t.string :status_text, null: false, default: "Open Entry"
      t.belongs_to :category, null: false
      t.timestamps
    end
  end
end
