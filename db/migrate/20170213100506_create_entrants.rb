class CreateEntrants < ActiveRecord::Migration[5.0]
  def change
    create_table :entrants do |t|
      t.integer :user_id
      t.integer :race_id
      t.integer :place
      t.timestamps
    end
  end
end
