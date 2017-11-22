class EntrantSerializer < ActiveModel::Serializer
  attributes :id, :ready, :finish_time, :place, :duration, :created_at, :updated_at

  belongs_to :user

  def duration
    object.duration
  end
end
