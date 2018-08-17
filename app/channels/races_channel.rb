class RacesChannel < ApplicationCable::Channel
  def subscribed
    update_race_instance
    stream_for(@race)
  end

  def unsubscribed
    stop_all_streams
  end

  def join_race
    return if current_user.blank?
    update_race_instance
    return if @race.started?
    if ability.cannot?(:enter, Race)
      notify_user(
        current_user,
        'race_join_failure', true,
        reason: 'Please make sure you have linked your twitch account and are not in another race.'
      )
      return
    end

    entrant = Entrant.new(user: current_user, race: @race)
    if entrant.save
      notify_race('race_entrants_updated')
      notify_user(current_user, 'race_join_success', false)
      notify_main('race_entrants_updated')
    else
      notify_user(current_user, 'race_join_failure', true, reason: get_errors_sentence(entrant))
    end
  end

  def part_race
    return if current_user.blank?
    update_race_instance
    return if @race.started?
    entrant = Entrant.find_by(race: @race, user: current_user)
    return if entrant.nil?

    if entrant.part
      notify_race('race_entrants_updated')
      notify_user(current_user, 'race_part_success', false)
      notify_main('race_entrants_updated')
    else
      notify_user(current_user, 'race_part_failure', true, reason: get_errors_sentence(entrant))
    end
  end

  def abandon_race
    return if current_user.blank?
    update_race_instance
    return unless @race.in_progress?
    entrant = Entrant.find_by(race: @race, user: current_user)
    return if entrant.nil?

    if entrant.part
      notify_race('race_entrants_updated')
      notify_user(current_user, 'race_abandon_success', false)
      @race.finish_if_possible
    else
      notify_user(current_user, 'race_abandon_failure', true, reason: get_errors_sentence(entrant))
    end
  end

  def rejoin_race
    return if current_user.blank?
    update_race_instance
    return unless @race.in_progress?
    entrant = Entrant.find_by(race: @race, user: current_user)
    return if entrant.nil?

    if entrant.rejoin
      notify_race('race_entrants_updated')
      notify_user(current_user, 'race_rejoin_success', false)
    else
      notify_user(current_user, 'race_rejoin_failure', true, reason: get_errors_sentence(entrant))
    end
  end

  def ready
    return if current_user.blank?
    update_race_instance
    return if @race.started?
    entrant = Entrant.find_by(user: current_user, race: @race)
    return if entrant.nil?

    if entrant.update(ready: true)
      notify_race('race_entrants_updated')
      notify_user(current_user, 'race_ready_success', false)
      @race.start_if_possible
    else
      notify_user(current_user, 'race_ready_failure', true, reason: get_errors_sentence(entrant))
    end
  end

  def unready
    return if current_user.blank?
    update_race_instance
    return if @race.started?
    entrant = Entrant.find_by(user: current_user, race: @race)
    return if entrant.nil?

    if entrant.update(ready: false)
      notify_race('race_entrants_updated')
      notify_user(current_user, 'race_unready_success', false)
    else
      notify_user(current_user, 'race_unready_failure', true, reason: get_errors_sentence(entrant))
    end
  end

  def done(data)
    return if current_user.blank?
    update_race_instance
    return unless @race.in_progress?
    entrant = Entrant.find_by(user: current_user, race: @race)
    return if entrant.nil?

    if entrant.done(data['server_time'])
      notify_race('race_entrants_updated')
      notify_user(current_user, 'race_done_success', false)
      @race.finish_if_possible
    else
      notify_user(current_user, 'race_done_failure', true, reason: get_errors_sentence(entrant))
    end
  end

  def kick_entrant(data)
    return if current_user.blank?
    update_race_instance
    return if @race.started?
    entrant = Entrant.find(data['entrant_id'])
    return if entrant.nil?
    if ability.cannot?(:kick, entrant)
      notify_user(current_user, 'race_kick_failure', true, reason: 'User must be inactive for 10 minutes.')
      return
    end

    if entrant.part
      notify_race('race_entrants_updated')
      notify_user(entrant.user, 'race_part_success', false)
      notify_user(entrant.user, 'race_kick_inactive', false)
      notify_main('race_entrants_updated')
    else
      notify_user(current_user, 'race_kick_failure', true, reason: get_errors_sentence(entrant))
    end
  end

  private

  def update_race_instance
    @race = Race.find(params['race_id'])
  end

  def notify_user(user, msg, error, extras = {})
    NotificationRaceBroadcastJob.perform_now(user, @race, msg, error, extras)
  end

  def notify_race(msg, extras = {})
    RaceBroadcastJob.perform_now(@race, msg, extras)
    return unless msg == 'race_entrants_updated'

    RaceBroadcastJob.perform_now(
      @race,
      'race_entrants_html',
      entrants_html: ApplicationController.render(partial: 'races/entrants_table', locals: {race: @race}),
      admin_html: ApplicationController.render(partial: 'races/admin_table', locals: {race: @race})
    )
  end

  def notify_main(status, extras = {})
    MainBroadcastJob.perform_now(status, @race, extras)
  end
end
