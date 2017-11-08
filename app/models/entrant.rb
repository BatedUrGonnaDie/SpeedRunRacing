class Entrant < ApplicationRecord
  belongs_to :race
  belongs_to :user

  validates_with EntrantValidator

  scope :readied, -> { where(ready: true) }
  scope :finished, -> { where.not(finish_time: nil) }

  def duration
    return nil unless race.finished?
    (finish_time - race.start_time) * 1000
  end
end
