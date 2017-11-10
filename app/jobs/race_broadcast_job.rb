class RaceBroadcastJob < ApplicationJob
  queue_as :default

  def perform(race, status)
    RacesChannel.broadcast_to(
      race,
      race: serialize_race(race),
      update: status
    )
  end

  private

  def serialize_race(r)
    ActiveModelSerializers::SerializableResource.new(
      r,
      include: ['entrants', 'entrants.user', 'game', 'category']
    ).as_json
  end
end
