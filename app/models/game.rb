class Game < ApplicationRecord
  has_many :categories
  has_many :races, through: :categories

  validates :srdc_id, uniqueness: true

  def to_param
    shortname
  end

  def completed_races_count
    races.where(status_text: Race::ENDED).count
  end
end
