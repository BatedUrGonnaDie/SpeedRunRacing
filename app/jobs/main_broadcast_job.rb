class MainBroadcastJob < ApplicationJob
  queue_as :default

  def perform(race, status)
    ActionCable.server.broadcast(
      'main_channel',
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
