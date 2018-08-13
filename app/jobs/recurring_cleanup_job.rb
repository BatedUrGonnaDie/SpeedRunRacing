class RecurringCleanupJob < ApplicationJob
  queue_as :recurring_cleanup

  after_perform do
    # Ghetto way to make this job repeat every 5 minutes
    self.class.set(wait: 5.minutes).perform_later
  end

  def perform
    open_races = Race.where(status_text: Race::OPEN)
    open_races.each do |race|
      # If nothing updated in last 30 minutes, assume race is dead and queue up deletion
      if race.updated_at + 30.minutes < Time.now.utc && race.entrants.count < 2
        race.update(status_text: Race::INACTIVE)
        race.queue_deletion!
      end
    end
  end
end
