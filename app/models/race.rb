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
end
