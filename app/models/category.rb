class Category < ApplicationRecord
  belongs_to :game
  has_many :races
  has_many :entrants, through: :races

  validates :srdc_id, uniqueness: true
end
