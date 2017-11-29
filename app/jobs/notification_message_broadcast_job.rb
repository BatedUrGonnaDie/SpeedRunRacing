class NotificationMessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(user, chat_room, error = false, extras = {})
    NotificationChannel.broadcast_to(
      user,
      generate_msg(chat_room, error, extras)
    )
  end

  private

  def generate_msg(chat_room, error, extras)
    msg = {
      chat_room: chat_room,
      status: status,
      error: error
    }
    extras.each do |k, v|
      msg[k] = v
    end
    msg
  end
end
