class AddIndexToGameSrdcId < ActiveRecord::Migration[5.1]
  def change
    add_index :games, :srdc_id, unique: true
  end
end
