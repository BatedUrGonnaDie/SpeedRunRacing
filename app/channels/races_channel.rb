class RacesChannel < ApplicationCable::Channel
  def subscribed
    stream_for(Race.find(params['race_id']))
  end

  def unsubscribed
    stop_all_streams
  end

  def join_race
    race = Race.find(params['race_id'])
    if race.started?
      NotificationBroadcastJob.perform_later(current_user, race, 'race_already_started')
      return
    end
    entrant = Entrant.new(user: current_user, race: race)
    if entrant.save
      RaceBroadcastJob.perform_later(race, 'race_entrants_updated')
      NotificationBroadcastJob.perform_later(current_user, race, 'race_entry_success')
    else
      NotificationBroadcastJob.perform_later(current_user, race, 'race_entry_failure')
    end
  end

  def part_race
    race = Race.find(params['race_id'])
    entrant = Entrant.find_by(race: race, user: current_user)
    if entrant.part
      RaceBroadcastJob.perform_later(race, 'race_entrants_updated')
      NotificationBroadcastJob.perform_later(current_user, race, 'race_part_success')
    else
      NotificationBroadcastJob.perform_later(current_user, race, 'race_part_failure')
    end
  end

  def rejoin_race
    race = Race.find(params['race_id'])
    entrant = Entrant.find_by(race: race, user: current_user)
    did_rejoin = entrant.rejoin
    if did_rejoin
      RaceBroadcastJob.perform_later(race, 'race_entrants_updated')
      NotificationBroadcastJob.perform_later(current_user, race, 'race_rejoin_success')
    else
      NotificationBroadcastJob.perform_later(current_user, race, 'race_rejoin_failure')
    end
  end

  def ready
    race = Race.find(params['race_id'])
    return if race.started?
    entrant = Entrant.find_by(user: current_user, race: race)
    return if entrant.nil?
    entrant.update(ready: true)
    RaceBroadcastJob.perform_later(race, 'race_entrants_updated')
    NotificationBroadcastJob.perform_later(current_user, race, 'race_entry_ready')
    race.start_if_possible
  end

  def unready
    race = Race.find(params['race_id'])
    if race.started?
      NotificationBroadcastJob.perform_later(current_user, race, 'race_in_progress')
    else
      entrant = Entrant.find_by(user: current_user, race: race)
      entrant.update(ready: false)
      RaceBroadcastJob.perform_later(race, 'race_entrants_updated')
      NotificationBroadcastJob.perform_later(current_user, race, 'race_entry_unready')
    end
  end

  def done
    race = Race.find(params['race_id'])
    entrant = Entrant.find_by(user: current_user, race: race)
    if entrant.done
      RaceBroadcastJob.perform_later(race, 'race_entrants_updated')
      NotificationBroadcastJob.perform_later(current_user, race, 'race_done_success')
      race.finish_if_possible
    else
      NotificationBroadcastJob.perform_later(current_user, race, 'race_done_failure')
    end
  end
end
