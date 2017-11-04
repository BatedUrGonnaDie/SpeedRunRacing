class MainChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'main_channel'
  end

  def create_race(cat_id)
    race = Race.new(category: Category.find(cat_id['cat_id']))
    if race.save
      # TODO: Need to actually figure this out
    else
      # TODO: And this part
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
