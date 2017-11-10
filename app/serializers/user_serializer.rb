class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :display_name, :created_at, :updated_at
end
