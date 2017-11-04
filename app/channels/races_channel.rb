class RacesChannel < ApplicationCable::Channel
  def subscribed
    stream_for(Race.find(params['race_id']))
  end

  def unsubscribed
    stop_all_streams
  end
end
