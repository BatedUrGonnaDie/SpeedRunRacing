class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.belongs_to :game, index: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
