class Race < ApplicationRecord
  has_many :entrants, dependant: :destroy
  belongs_to :category
  has_one :game, through: :category
  has_many :users, through: :entrants

  OPEN = 'Open Entry'.freeze
  PROGRESS = 'In Progress'.freeze
  ENDED = 'Ended'.freeze
  ACTIVE_RACES = [Race::OPEN, Race::PROGRESS].freeze

  scope :active, -> { includes(:game, :category, :entrants).where(status_text: Race::ACTIVE_RACES) }
  scope :completed, -> { includes(:game, :category, :entrants).where(status_text: Race::ENDED) }

  def in_progress?
    status_text == Race::PROGRESS
  end

  def contains_user?(user)
    return nil if user.nil?
    users.map(&:id).include?(user.id)
  end

  def entrant_for_user(user)
    return nil if user.nil?
    entrants.where(user_id: user.id).try(:[], 0)
  end

  def started?
    start_time.present?
  end

  def finished?
    finish_time.present?
  end

  def recalculate_places
    # TODO: needs testing to make sure this acutally works correctly
    finished_entrants = entrants.where.not(finish_time: nil).order('entrants.finish_time ASC')
    finished_entrants.each_with_index { |e, i| e.place = i + 1 }
  end

  def start
    return if started?
    update(
      start_time: DateTime.now.utc + 10.seconds,
      status_text: Race::PROGRESS
    )
    RaceBroadcastJob.perform_later(self, 'race_started')
    MainBroadcastJob.perform_later(self, 'race_started')
  end

  def start_if_possible
    start if entrants.count == entrants.readied.count && entrants.readied.count >= 2
  end

  def finish
    return if finished?
    update(
      finish_time: entrants.order('entrants.place DESC').limit(1).first.finish_time,
      status_text: Race::ENDED
    )
    recalculate_places
    RaceBroadcastJob.perform_later(self, 'race_completed')
    MainBroadcastJob.perform_later(self, 'race_completed')
  end

  def finish_if_possible
    if entrants.count == entrants.finished.count
      if entrants.completed > 0
        finish
      else
        # If everyone forfeit the race or were disqualified, delete the race from history
        race.destroy
      end
    end
  end

  def duration
    return nil unless finished?
    (finish_time - start_time) * 1000
  end
end
