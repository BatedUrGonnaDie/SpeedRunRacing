class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :name, null: false
      t.string :shortname, null: false

      t.timestamps
    end
  end
end
