class RaceBroadcastJob < ApplicationJob
  queue_as :default

  def perform(race, status)
    RacesChannel.broadcast_to(
      race,
      race: race,
      game: race.game,
      category: race.category,
      entrants: race.entrants.load,
      update: status
    )
  end
end
