class AddPrecisionDatetimes < ActiveRecord::Migration[5.1]
  def change
    change_column :entrants, :finish_time, :datetime, limit: 6
    change_column :races, :start_time, :datetime, limit: 6
    change_column :races, :finish_time, :datetime, limit: 6
  end
end
