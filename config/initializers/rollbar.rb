Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']

  config.enabled = (Rails.env == 'production')

  config.js_enabled = true
  config.js_options = {
    accessToken: "85e887cd33764f4fb70bb23a29be4191",
    captureUncaught: true,
    payload: {
      environment: "production"
    }
  }
end
