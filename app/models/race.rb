class Race < ApplicationRecord
  has_many :entrants
  belongs_to :category
  has_one :game, through: :category

  OPEN = 'Open Entry'.freeze
  PROGRESS = 'In Progress'.freeze
  ENDED = 'Ended'.freeze
  ACTIVE_RACES = [Race::OPEN, Race::PROGRESS].freeze

  scope :active, -> { includes(:game, :category, :entrants).where(status_text: Race::ACTIVE_RACES) }
  scope :completed, -> { includes(:game, :category, :entrants).where(status_text: Race::ENDED) }

  def started?
    start_time.present?
  end

  def finished?
    finish_time.present?
  end

  def start
    return if started?
    update_attributes(
      start_time: DateTime.now.utc,
      status_text: Race::PROGRESS
    )
  end

  def finish
    return if finished?
    update_attributes(
      finish_time: DateTime.now.utc,
      status_text: Race::ENDED
    )
  end
end
