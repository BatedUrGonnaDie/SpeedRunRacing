class RaceBroadcastJob < ApplicationJob
  queue_as :default

  def perform(race, game, category, entrants)
    ActionCable.server.broadcast(
      'races_channel_global',
      race: race,
      game: game,
      category: category,
      entrants: entrants
    )
  end
end
