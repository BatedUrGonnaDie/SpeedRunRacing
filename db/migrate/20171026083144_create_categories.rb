class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.belongs_to :game, index: true
      t.string :srdc_id, null: false
      t.string :name, null: false
      t.string :weblink, null: false

      t.timestamps
    end
  end
end
