class NotificationChannel < ApplicationCable::Channel
  def subscribed
    reject if current_user.blank?
    stream_for(current_user)
  end

  def unsubscribed
    stop_all_streams
  end
end
