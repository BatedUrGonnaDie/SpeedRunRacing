class RemoveRaceJob < ApplicationJob
  queue_as :default

  def perform(race)
    RaceBroadcastJob.perform_now(race, 'race_deleted')
    race.destroy!
  end
end
