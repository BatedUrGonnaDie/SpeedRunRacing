class Category < ApplicationRecord
  belongs_to :game
  has_many :races

  validates :srdc_id, uniqueness: true
end
