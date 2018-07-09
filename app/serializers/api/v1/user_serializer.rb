class Api::V1::UserSerializer < Api::V1::ApplicationSerializer
  attributes :id, :username, :display_name, :created_at, :updated_at

  def id
    object.id.to_s
  end
end
