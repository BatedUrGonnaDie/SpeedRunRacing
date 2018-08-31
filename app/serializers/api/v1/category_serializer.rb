class Api::V1::CategorySerializer < Api::V1::ApplicationSerializer
  attributes :id, :srdc_id, :name, :weblink, :race_count, :entrant_count, :created_at, :updated_at

  has_one :game, serializer: Api::V1::GameSerializer

  def id
    object.id.to_s
  end

  def race_count
    object.races.count
  end

  def entrant_count
    object.entrants.count
  end
end
