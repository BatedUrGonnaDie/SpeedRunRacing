class MessagesChannel < ApplicationCable::Channel
  def subscribed
    update_chat_room_instance
    stream_for(@chat_room)
  end

  def unsubscribed
    stop_all_streams
  end

  def send_message(data)
    return if current_user.blank?
    update_chat_room_instance
    msg = data['message']
    return if msg.empty? || @chat_room.locked?

    chat_msg = ChatMessage.create(chat_room: @chat_room, user: current_user, body: msg)
    if chat_msg.valid?
      push_message(chat_msg, 'chat_message_created')
    else
      notify_user('chat_message_create_failure', true, reason: get_errors_sentence(chat_msg))
    end
  end

  private

  def update_chat_room_instance
    @chat_room ||= ChatRoom.find(params['room_id'])
    @chat_room.reload
  end

  def push_message(chat_msg, status)
    MessageBroadcastJob.perform_now(@chat_room, chat_msg, status)
  end

  def notify_user(msg, error, extras = {})
    NotificationMessageBroadcastJob.perform_now(current_user, @chat_room, msg, error, extras)
  end
end
