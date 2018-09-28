class RaceBroadcastJob < ApplicationJob
  queue_as :default

  def perform(race, status, extras = {})
    if race.is_a?(String)
      ActionCable.server.broadcast(
        race,
        generate_msg(race, status, extras)
      )
    else
      RacesChannel.broadcast_to(
        race,
        generate_msg(race, status, extras)
      )
    end
  end

  private

  def generate_msg(race, status, extras)
    msg = {
      race: serialize_race(race),
      update: status
    }
    extras.each do |k, v|
      msg[k] = v
    end
    msg
  end

  def serialize_race(run)
    ActiveModelSerializers::SerializableResource.new(
      run,
      include: ['entrants', 'entrants.user', 'game', 'category']
    ).as_json
  end
end
