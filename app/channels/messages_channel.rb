class MessagesChannel < ApplicationCable::Channel
  def subscribed
    update_chat_room_instance
    stream_for(@chat_room)
  end

  def unsubscribed
    stop_all_streams
  end

  private

  def update_chat_room_instance
    @chat_room = ChatRoom.find(params['room_id'])
  end

  def push_message(chat_msg)
    MessageBroadcastJob.perform_later(@chat_room, chat_msg)
  end
end
