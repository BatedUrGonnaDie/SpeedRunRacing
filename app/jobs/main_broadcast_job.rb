class MainBroadcastJob < ApplicationJob
  queue_as :default

  def perform(status, race = nil, extras = {})
    ActionCable.server.broadcast(
      'main_channel',
      generate_msg(status, race, extras)
    )
  end

  private

  def generate_msg(status, race, extras)
    msg = {
      status: status,
      race: serialize_race(race)
    }
    extras.each do |k, v|
      msg[k] = v
    end
    msg
  end

  def serialize_race(r)
    ActiveModelSerializers::SerializableResource.new(
      r,
      include: ['entrants', 'entrants.user', 'game', 'category']
    ).as_json
  end
end
