class Race < ApplicationRecord

  has_many :entrants

  scope :active, -> { where("archived == false") }
end
