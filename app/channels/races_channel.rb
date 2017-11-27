class RacesChannel < ApplicationCable::Channel
  def subscribed
    update_race_instance
    stream_for(@race)
  end

  def unsubscribed
    stop_all_streams
  end

  def join_race
    update_race_instance
    return if @race.started?
    entrant = Entrant.new(user: current_user, race: @race)
    if entrant.save
      notify_race('race_entrants_updated')
      notify_user('race_join_success', false)
    else
      notify_user('race_join_failure', true, reason: get_errors_sentence(entrant))
    end
  end

  def part_race
    update_race_instance
    return if @race.started?
    entrant = Entrant.find_by(race: @race, user: current_user)
    if entrant.part
      notify_race('race_entrants_updated')
      notify_user('race_part_success', false)
    else
      notify_user('race_part_failure', true, reason: get_errors_sentence(entrant))
    end
  end

  def abandon_race
    update_race_instance
    return unless @race.in_progress?
    entrant = Entrant.find_by(race: @race, user: current_user)
    if entrant.part
      notify_race('race_entrants_updated')
      notify_user('race_abandon_success', false)
      @race.finish_if_possible
    else
      notify_user('race_abandon_failure', true, reason: get_errors_sentence(entrant))
    end
  end

  def rejoin_race
    update_race_instance
    return unless @race.in_progress?
    entrant = Entrant.find_by(race: @race, user: current_user)
    return if entrant.nil?
    if entrant.rejoin
      notify_race('race_entrants_updated')
      notify_user('race_rejoin_success', false)
    else
      notify_user('race_rejoin_failure', true, reason: get_errors_sentence(entrant))
    end
  end

  def ready
    update_race_instance
    return if @race.started?
    entrant = Entrant.find_by(user: current_user, race: @race)
    return if entrant.nil?
    if entrant.update(ready: true)
      notify_race('race_entrants_updated')
      notify_user('race_ready_success', false)
      @race.start_if_possible
    else
      notify_user('race_ready_failure', true, reason: get_errors_sentence(entrant))
    end
  end

  def unready
    update_race_instance
    return if @race.started?
    entrant = Entrant.find_by(user: current_user, race: @race)
    if entrant.update(ready: false)
      notify_race('race_entrants_updated')
      notify_user('race_unready_success', false)
    else
      notify_user('race_unready_failure', true, reason: get_errors_sentence(entrant))
    end
  end

  def done
    update_race_instance
    return unless @race.in_progress?
    entrant = Entrant.find_by(user: current_user, race: @race)
    if entrant.done
      notify_race('race_entrants_updated')
      notify_user('race_done_success', false)
      @race.finish_if_possible
    else
      notify_user('race_done_failure', true, reason: get_errors_sentence(entrant))
    end
  end

  private

  def update_race_instance
    @race = Race.find(params['race_id'])
  end

  def notify_user(msg, error, extras = {})
    NotificationRaceBroadcastJob.perform_later(current_user, @race, msg, error, extras)
  end

  def notify_race(msg)
    RaceBroadcastJob.perform_later(@race, msg)
  end
end
