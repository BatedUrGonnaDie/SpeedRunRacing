class MainChannel < ApplicationCable::Channel
  include Rails.application.routes.url_helpers

  def subscribed
    stream_from 'main_channel'
  end

  def create_race(data)
    race = Race.new(category: Category.find(data['cat_id']))
    if race.save
      ChatRoom.create(race: race)
      MainBroadcastJob.perform_later(
        'race_created',
        race,
        html: ApplicationController.render(partial: 'races/active_race_td', locals: {race: race})
      )
      NotificationRaceBroadcastJob.perform_later(
        current_user,
        race,
        'race_create_success',
        false,
        location: race_path(race)
      )
    else
      NotificationRaceBroadcastJob.perform_later(
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
