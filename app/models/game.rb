class Game < ApplicationRecord
  has_many :categories, dependent: :destroy
  has_many :races, through: :categories

  validates :srdc_id, uniqueness: true

  def self.searchable_columns
    %i[name shortname]
  end

  def to_param
    shortname
  end

  def completed_races_count
    races.where(status_text: Race::ENDED).count
  end
end
