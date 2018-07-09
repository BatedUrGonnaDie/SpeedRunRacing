class Api::V1::EntrantSerializer < Api::V1::ApplicationSerializer
  attributes :id, :race_id, :place, :finish_time, :ready, :duration, :created_at, :updated_at

  belongs_to :user, serializer: Api::V1::UserSerializer

  def duration
    object.duration
  end

  def id
    object.id.to_s
  end
end
