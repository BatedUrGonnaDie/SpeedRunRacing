class RacesChannel < ApplicationCable::Channel
  def subscribed
    @race = Race.find(params['race_id'])
    stream_for(@race)
  end

  def unsubscribed
    stop_all_streams
  end

  def join_race
    return if @race.started?
    entrant = Entrant.new(user: current_user, race: @race)
    if entrant.save
      notify_race('race_entrants_updated')
      notify_user('race_entry_success')
    else
      notify_user('race_entry_failure')
    end
  end

  def part_race
    entrant = Entrant.find_by(race: @race, user: current_user)
    if entrant.part
      notify_race('race_entrants_updated')
      notify_user('race_part_success')
    else
      notify_user('race_part_failure')
    end
  end

  def rejoin_race
    return if @race.finished?
    entrant = Entrant.find_by(race: @race, user: current_user)
    return if entrant.nil?
    if entrant.rejoin
      notify_race('race_entrants_updated')
      notify_user('race_rejoin_success')
    else
      notify_user('race_rejoin_failure')
    end
  end

  def ready
    return if @race.started?
    entrant = Entrant.find_by(user: current_user, race: @race)
    return if entrant.nil?
    entrant.update(ready: true)
    notify_race('race_entrants_updated')
    notify_user('race_entry_ready')
    @race.start_if_possible
  end

  def unready
    if @race.started?
      notify_user('race_in_progress')
    else
      entrant = Entrant.find_by(user: current_user, race: @race)
      entrant.update(ready: false)
      notify_race('race_entrants_updated')
      notify_user('race_entry_unready')
    end
  end

  def done
    return unless @race.in_progress?
    entrant = Entrant.find_by(user: current_user, race: @race)
    if entrant.done
      notify_race('race_entrants_updated')
      notify_user('race_done_success')
      @race.finish_if_possible
    else
      notify_user('race_done_failure')
    end
  end

  private

  def notify_user(msg)
    NotificationBroadcastJob.perform_later(current_user, @race, msg)
  end

  def notify_race(msg)
    RaceBroadcastJob.perform_later(@race, msg)
  end
end
