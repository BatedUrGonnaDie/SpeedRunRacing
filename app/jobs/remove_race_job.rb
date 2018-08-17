class RemoveRaceJob < ApplicationJob
  queue_as :default

  def perform(race)
    # Use perform_now so that we don't error in the job later since the race will be destoryed
    RaceBroadcastJob.perform_now(race, 'race_deleted')
    race.destroy!
  end
end
