class NotificationRaceBroadcastJob < ApplicationJob
  queue_as :default

  def perform(user, race, status, error = false, extras = {})
    NotificationChannel.broadcast_to(
      user,
      generate_msg(race, status, error, extras)
    )
  end

  private

  def generate_msg(race, status, error, extras)
    msg = {
      race: race,
      status: status,
      error: error
    }
    extras.each do |k, v|
      msg[k] = v
    end
    msg
  end
end
