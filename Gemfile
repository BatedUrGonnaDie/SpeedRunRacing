source 'https://rubygems.org'
ruby '2.4.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Framework and Servers
gem 'puma'
gem 'rails'

# API Generation
gem 'active_model_serializers'
gem 'jbuilder'

# Databases and Information Storage
gem 'pg'
gem 'redis'

# Configuration
gem 'figaro'

# View styles and building
gem 'bootstrap-sass'
gem 'bootswatch-rails'
gem 'haml-rails'
gem 'jquery-rails'
gem 'sass-rails'
gem 'slim-rails'
gem 'uglifier'

# Authentication
gem 'devise'
gem 'omniauth-oauth2'
gem 'omniauth-twitch'

# Jobs
gem 'delayed_job_active_record'

# External Communications
gem 'httparty'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'flamegraph'
  gem 'memory_profiler'
  gem 'meta_request'
  gem 'pry-rails'
  gem 'rack-mini-profiler'
  gem 'rails-erd', require: false
  gem 'rubocop', require: false
  gem 'stackprof'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
