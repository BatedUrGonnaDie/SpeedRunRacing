require 'rollbar'
Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']

  config.enabled = (Rails.env == 'production')
  config.exception_level_filters.merge!('ActionController::RoutingError' => 'ignore')
end
