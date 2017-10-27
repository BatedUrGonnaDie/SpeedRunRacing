class Race < ApplicationRecord
  has_many :entrants
  belongs_to :category, required: true
  has_one :game, through: :category

  after_commit { RaceRelayJob.perform_later(self) }

  OPEN = 'Open Entry'.freeze
  PROGRESS = 'In Progress'.freeze
  ENDED = 'Ended'.freeze
  ACTIVE_RACES = [Race::OPEN, Race::PROGRESS].freeze

  scope :active, -> { includes(:game, :category).where(status_text: Race::ACTIVE_RACES) }
end
