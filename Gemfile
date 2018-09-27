source 'https://rubygems.org'
ruby '2.5.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# API Generation
gem 'active_model_serializers'
gem 'api-pagination'

# Asset Generation
gem 'sass-rails'
gem 'uglifier'

# Authentication and Authorization
gem 'cancancan'
gem 'devise'
gem 'doorkeeper'
gem 'omniauth-oauth2'
gem 'omniauth-twitch'
gem 'rolify'

# Configuration
gem 'figaro'

# Databases and Information Storage
gem 'pg'
gem 'redis'
gem 'textacular', '~> 5.0'

# External Communications
gem 'httparty'
gem 'rack-cors', require: 'rack/cors'

# Framework and Servers
gem 'puma'
gem 'rails'

# Frontend Resources
gem 'gon'
gem 'webpacker'

# Jobs
gem 'daemons'
gem 'delayed_job_active_record'

# View Building
gem 'administrate'
gem 'haml-rails'
gem 'kaminari'
gem 'slim-rails'

# View styles
gem 'bootstrap'
gem 'bootstrap4-kaminari-views'
gem 'bootswatch'
gem 'font-awesome-sass'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen'
  gem 'meta_request'
  gem 'pry-rails'
  gem 'rubocop', require: false
end

group :test do
  gem 'action-cable-testing'
  gem 'factory_bot_rails'
  gem 'json-schema'
  gem 'json-schema-rspec'
  gem 'rspec-rails', require: false
  gem 'simplecov', require: false
end

group :production do
  gem 'rollbar'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
