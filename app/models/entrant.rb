class Entrant < ApplicationRecord
  belongs_to :race
  belongs_to :user

  validates_with EntrantValidator

  FORFEITED    = -1
  DISQUALIFIED = -2

  scope :readied, -> { where(ready: true) }
  scope :completed, -> { where('place > 0') }
  scope :finished, -> { where.not(finish_time: nil) }

  def part
    if race.started?
      update(place: Entrant::FORFEITED, finish_time: nil)
    else
      destroy
    end
  end

  def done
    return false unless race.started?
    update(finish_time: DateTime.now.utc, place: (race.entrants.completed.count + 1))
  end

  def rejoin
    return false unless race.in_progress?
    update(place: nil, finish_time: nil)
  end

  def disqualify
    update(place: Entrant::DISQUALIFIED, finish_time: nil)
  end

  def completed?
    finish_time.present?
  end

  def finished?
    place.present?
  end

  def duration
    return nil unless race.finished?
    (finish_time - race.start_time) * 1000
  end
end
