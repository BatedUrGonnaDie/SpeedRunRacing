class EntrantSerializer < ActiveModel::Serializer
  attributes :id, :ready, :finish_time, :place, :created_at, :updated_at

  belongs_to :user
end
