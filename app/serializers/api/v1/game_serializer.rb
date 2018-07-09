class Api::V1::GameSerializer < Api::V1::ApplicationSerializer
  attributes :id, :srdc_id, :name, :shortname, :cover_small, :cover_large, :weblink, :created_at, :updated_at

  def id
    object.id.to_s
  end
end
