class Game < ApplicationRecord
  has_many :categories, dependent: :destroy
  has_many :races, through: :categories
  has_many :entrants, through: :races

  validates :srdc_id, uniqueness: true

  def self.search(term)
    term.strip!
    return Game.none if term.blank?
    exact_match = where('shortname ILIKE ?', term)
    exact_match + fuzzy_search(name: term).where.not(id: exact_match.map(&:id))
  end

  def to_param
    shortname
  end
end
