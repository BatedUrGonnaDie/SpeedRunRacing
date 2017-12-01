source 'https://rubygems.org'
ruby '2.4.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# API Generation
gem 'active_model_serializers'

# Asset Generation
gem 'sass-rails'
gem 'uglifier'

# Authentication
gem 'devise'
gem 'omniauth-oauth2'
gem 'omniauth-twitch'

# Configuration
gem 'figaro'

# Databases and Information Storage
gem 'pg'
gem 'redis', '~> 3.0'
gem 'textacular', '~> 5.0'

# External Communications
gem 'httparty'
gem 'rack-cors', require: 'rack/cors'

# Framework and Servers
gem 'puma'
gem 'rails'

# Frontend Resources
gem 'gon'
gem 'jquery-rails'
gem 'turbolinks'
gem 'twitter-typeahead-rails'

# Jobs
gem 'delayed_job_active_record'

# View Building
gem 'haml-rails'
gem 'kaminari'
gem 'slim-rails'

# View styles
gem 'bootstrap-kaminari-views'
gem 'bootstrap-sass'
gem 'bootswatch-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'flamegraph'
  gem 'listen'
  gem 'memory_profiler'
  gem 'meta_request'
  gem 'pry-rails'
  gem 'rack-mini-profiler'
  gem 'rails-erd', require: false
  gem 'rubocop', require: false
  gem 'stackprof'
end

group :production do
  gem 'rollbar'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
