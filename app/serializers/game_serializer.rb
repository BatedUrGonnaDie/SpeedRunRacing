class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :shortname, :weblink, :cover_small, :cover_large, :created_at, :updated_at
end
