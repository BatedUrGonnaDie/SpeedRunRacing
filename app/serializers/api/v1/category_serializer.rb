class Api::V1::CategorySerializer < Api::V1::ApplicationSerializer
  attributes :id, :srdc_id, :name, :weblink, :created_at, :updated_at

  has_one :game, serializer: Api::V1::GameSerializer

  def id
    object.id.to_s
  end
end
