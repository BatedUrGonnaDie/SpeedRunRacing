class MainChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'main_channel'
  end

  def create_race(data)
    return if current_user.blank?
    if ability.cannot?(:create, Race)
      NotificationRaceBroadcastJob.perform_now(
        current_user,
        nil,
        'race_create_failure',
        true,
        reason: 'Error creating race, please make sure you have linked your twitch account and are not in another race!'
      )
      return
    end
    race = Race.new(category: Category.find(data['cat_id']), creator_id: current_user.id)
    if race.save
      ChatRoom.create(race: race)
      MainBroadcastJob.perform_now(
        'race_created',
        race,
        html: ApplicationController.render(partial: 'races/active_race_td', locals: {race: race})
      )
      NotificationRaceBroadcastJob.perform_now(
        current_user,
        race,
        'race_create_success',
        false,
        location: Rails.application.routes.url_helpers.race_path(race)
      )
    else
      NotificationRaceBroadcastJob.perform_now(
        current_user,
        nil,
        'race_create_failure',
        true,
        reason: get_errors_sentence(race)
      )
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
