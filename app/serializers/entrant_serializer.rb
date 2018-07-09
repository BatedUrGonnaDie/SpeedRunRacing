class EntrantSerializer < ActiveModel::Serializer
  attributes :id, :ready, :finish_time, :place, :duration

  belongs_to :user

  def duration
    object.duration
  end
end
