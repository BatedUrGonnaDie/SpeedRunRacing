class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(chat_room, chat_msg, status)
    MessagesChannel.broadcast_to(
      chat_room,
      message: serialize_msg(chat_msg),
      update: status
    )
  end

  private

  def serialize_msg(chat_msg)
    ActiveModelSerializers::SerializableResource.new(chat_msg).as_json
  end
end
