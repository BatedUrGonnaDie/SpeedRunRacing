class CreateRaces < ActiveRecord::Migration[5.0]
  def change
    create_table :races do |t|
      t.string :status_text, null: false, default: "Open Entry"
      t.belongs_to :category, null: false
      t.datetime :start_time
      t.datetime :finish_time

      t.timestamps
    end
  end
end
