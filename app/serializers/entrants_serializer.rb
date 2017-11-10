class EntrantsSerializer < ActiveModel::Serializer
  attributes :id, :ready, :finish_time, :place, :created_at, :updated_at

  has_one :user
end
