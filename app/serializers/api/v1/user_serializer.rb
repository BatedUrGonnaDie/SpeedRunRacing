class Api::V1::UserSerializer < Api::V1::ApplicationSerializer
  attributes :id, :username, :display_name, :twitch_id, :twitch_name, :twitch_display_name, :created_at, :updated_at
end
