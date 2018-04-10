class AddIndexToCategoriesSrdcId < ActiveRecord::Migration[5.1]
  def change
    add_index :categories, :srdc_id, unique: true
  end
end
