class Race < ApplicationRecord
  has_many :entrants
  belongs_to :category, required: true
  has_one :game, through: :category

  after_commit { RaceRelayJob.perform_later(self) }
end
