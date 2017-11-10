class RaceSerializer < ActiveModel::Serializer
  attributes :id, :status_text, :start_time, :finish_time

  belongs_to :category
  has_one :game
  has_many :entrants
  has_many :users
end
