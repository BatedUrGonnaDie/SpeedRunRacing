class Game < ApplicationRecord
  has_many :categories
  has_many :races, through: :categories

  def to_param
    shortname
  end
end
