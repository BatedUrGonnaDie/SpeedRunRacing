class AddRaceCreatorToRaces < ActiveRecord::Migration[5.2]
  def change
    add_column :races, :creator_id, :bigint, index: true
    add_foreign_key :races, :users, column: :creator_id
  end
end
