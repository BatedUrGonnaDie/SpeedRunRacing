class RaceRelayJob < ApplicationJob
  queue_as :default

  def perform(race)
    ActionCable.server.broadcast('races', race: race)
  end
end
