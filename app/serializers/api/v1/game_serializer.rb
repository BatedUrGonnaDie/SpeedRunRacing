class Api::V1::GameSerializer < Api::V1::ApplicationSerializer
  attributes :id, :srdc_id, :name, :shortname, :cover_small, :cover_large, :weblink,
             :race_count, :entrant_count, :created_at, :updated_at

  def id
    object.id.to_s
  end

  def race_count
    object.races.count
  end

  def entrant_count
    object.entrants.count
  end
end
