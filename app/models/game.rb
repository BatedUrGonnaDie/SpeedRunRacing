class Game < ApplicationRecord
  has_many :categories
  has_many :races, through: :categories

  def to_param
    shortname
  end

  def completed_races_count
    races.where(status_text: Race::ENDED).count
  end
end
