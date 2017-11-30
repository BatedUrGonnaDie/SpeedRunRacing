class ChatMessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :updated_at, :created_at

  belongs_to :user
end
