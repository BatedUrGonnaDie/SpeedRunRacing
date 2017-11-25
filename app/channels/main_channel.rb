class MainChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'main_channel'
  end

  def create_race(data)
    race = Race.new(category: Category.find(data['cat_id']))
    if race.save
      MainBroadcastJob.perform_later(race, 'race_created')
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
