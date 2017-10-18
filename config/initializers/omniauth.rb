Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitch, ENV['SRR_TWITCH_CLIENT_ID'], ENV['SRR_TWITCH_CLIENT_SECRET']
end

