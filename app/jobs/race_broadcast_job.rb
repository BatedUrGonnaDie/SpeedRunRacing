class RaceBroadcastJob < ApplicationJob
  queue_as :default

  def perform(race)
    ActionCable.server.broadcast(
      'main_channel',
      race: race,
      game: race.game,
      category: race.category,
      update: 'race_created'
    )
  end
end
