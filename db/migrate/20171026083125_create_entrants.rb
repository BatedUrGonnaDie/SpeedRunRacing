class CreateEntrants < ActiveRecord::Migration[5.1]
  def change
    create_table :entrants do |t|
      t.belongs_to :user, index: true
      t.belongs_to :race, index: true
      t.integer    :place
      t.bigint     :finish_time
      t.boolean    :ready, default: false

      t.timestamps
    end
  end
end
