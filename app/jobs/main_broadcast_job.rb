class MainBroadcastJob < ApplicationJob
  queue_as :default

  def perform(race, status)
    ActionCable.server.broadcast(
      'main_channel',
      race: race,
      game: race.game,
      category: race.category,
      entrants: race.entrants.load,
      update: status
    )
  end
end
