class Race < ApplicationRecord
  has_many :entrants
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
    users.map(&:id).include?(user.id)
  end

  def started?
    start_time.present?
  end

  def finished?
    finish_time.present?
  end

  def start
    return if started?
    update_attributes(
      start_time: DateTime.now.utc + 20.seconds,
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
    update_attributes(
      finish_time: DateTime.now.utc,
      status_text: Race::ENDED
    )
    RaceBroadcastJob.perform_later(self, 'race_completed')
    MainBroadcastJob.perform_later(self, 'race_completed')
  end

  def finish_if_possible
    finish if entrants.count == entrants.finished.count
  end

  def duration
    return nil unless finished?
    (finish_time - start_time) * 1000
  end
end
