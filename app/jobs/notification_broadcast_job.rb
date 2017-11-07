class NotificationBroadcastJob < ApplicationJob
  include Rails.application.routes.url_helpers
  queue_as :default

  def perform(user, race, status)
    NotificationChannel.broadcast_to(
      user,
      race: race,
      update: status,
      location: race_path(race)
    )
  end
end
