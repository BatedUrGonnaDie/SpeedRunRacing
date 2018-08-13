require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SpeedRunRacing
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Configure cors headers for the public api
    # POST is only allowed because we need it for the timesync endpoint
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/api/*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

    config.to_prepare do
      Doorkeeper::AuthorizationsController.layout 'application'
    end

    Rails.application.config.action_cable.disable_request_forgery_protection = true

    config.active_job.queue_adapter = :delayed_job
  end
end
