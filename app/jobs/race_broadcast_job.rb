class RaceBroadcastJob < ApplicationJob
  queue_as :default

  def perform(race, status, extras)
    RacesChannel.broadcast_to(
      race,
      generate_msg(race, status, extras)
    )
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
