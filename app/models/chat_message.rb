class ChatMessage < ApplicationRecord
  belongs_to :chat_room, required: true
  belongs_to :user, required: true
end
