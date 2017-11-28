class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :srdc_id, null: false
      t.string :name, null: false
      t.string :shortname, null: false
      t.string :cover_large, null: false
      t.string :cover_small, null: false
      t.string :weblink, null: false

      t.timestamps
    end
  end
end
