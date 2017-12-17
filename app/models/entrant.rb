class Entrant < ApplicationRecord
  belongs_to :race
  belongs_to :user

  validates_with EntrantCreateValidator, on: :create
  validates_with EntrantAlwaysValidator

  FORFEITED    = -1
  DISQUALIFIED = -2

  scope :readied, -> { where(ready: true) }
  scope :completed, -> { where('place > 0') }
  scope :finished, -> { where.not(place: nil) }

  def part
    return false if race.finished?
    if race.started?
      update(place: Entrant::FORFEITED, finish_time: nil)
    else
      destroy
    end
  end

  def done(server_time)
    return false unless race.in_progress?
    update(finish_time: Time.parse(server_time), place: (race.entrants.completed.count + 1))
  end

  def rejoin
    return false unless race.in_progress?
    update_success = update(place: nil, finish_time: nil)
    race.recalculate_places
    update_success
  end

  def disqualify
    update(place: Entrant::DISQUALIFIED, finish_time: nil)
    race.recalculate_places
  end

  def completed?
    finish_time.present?
  end

  def finished?
    place.present?
  end

  def duration
    return nil if !race.started? || finish_time.nil?
    (finish_time - race.start_time)
  end
end
