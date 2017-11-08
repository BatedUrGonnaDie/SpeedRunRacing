class MainChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'main_channel'
  end

  def create_race(data)
    race = Race.new(category: Category.find(data['cat_id']))
    if race.save
      MainBroadcastJob.perform_later(race, 'race_created')
      NotificationBroadcastJob.perform_later(current_user, race, 'race_create_success')
    else
      NotificationBroadcastJob.perform_later(current_user, nil, 'race_create_failure')
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
