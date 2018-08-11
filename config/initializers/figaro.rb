Figaro.require_keys('DATABASE_URL', 'SRR_TWITCH_CLIENT_ID', 'SRR_TWITCH_CLIENT_SECRET')
if Rails.env.production?
  Figaro.require_keys('SECRET_KEY_BASE', 'RAILS_LOG_TO_STDOUT', 'RAILS_SERVE_STATIC_FILES',
                      'REDIS_URL', 'EMAIL_HOSTNAME', 'EMAIL_PASSWORD', 'EMAIL_PORT', 'EMAIL_USERNAME',
                      'MAILER_HOST', 'ROLLBAR_ACCESS_TOKEN')
end
