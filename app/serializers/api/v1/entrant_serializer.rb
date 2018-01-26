class Api::V1::EntrantSerializer < Api::V1::ApplicationSerializer
  attributes :id, :race_id, :place, :finish_time, :ready, :created_at, :updated_at

  belongs_to :user, serializer: Api::V1::UserSerializer
end
