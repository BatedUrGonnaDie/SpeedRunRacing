class LockChatRoomJob < ApplicationJob
  queue_as :default

  def perform(chat_room)
    chat_room.update(locked: true)
  end
end
