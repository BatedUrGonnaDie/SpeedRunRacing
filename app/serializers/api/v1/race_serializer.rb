class Api::V1::RaceSerializer < Api::V4::ApplicationSerializer
  attributes :id, :status_text, :start_time, :finish_time, :created_at, :updated_at

  has_one :game, serializer: Api::V1::GameSerializer
  belongs_to :category, serializer: Api::V1::CategorySerializer
  has_many :entrants, serializer: Api::V1::EntrantSerializer
end
