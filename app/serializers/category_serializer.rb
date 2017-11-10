class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :weblink, :created_at, :updated_at
end
