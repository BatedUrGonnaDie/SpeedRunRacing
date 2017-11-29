class ChatMessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :udpated_at, :created_at

  belongs_to :user
end
