# SpeedRunRacing

A modern racing website for speedrunners to compete against eachother.

# Development

### Requirements
- Ruby 2.3+ (gemfile defines 2.5 but no features above 2.3 are used, 2.3 is earliest release not at EoL)
- Postgres (assumes the pg service is already running)
- Node/Yarn
- Redis (assumes the redis service is already running)

### Setup
1. `cp config/application.example.yml config/application.yml`
2. Fill out any variables in there under `development` key
3. `bundle install`
4. `yarn install`
5. `rake db:setup`
6. (Optional) `rake sync_srdc` to retrieve all games and categories from speedrun.com
7. `rails s` in one terminal, and then `rake jobs:work` in a separate terminal

# Goals

1. ~~Full user login, with the ability to link twitch accounts~~ Completed
2. ~~Race coordinator~~ Completed
3. ~~Websocket server that connects users to coordinator to allow native
in browser racing~~ Completed
4. ~~Better handling of errors from the server~~ Completed
5. ~~Finish last pages that have holes in them~~ Completed
6. ~~Chat rooms and messages for race rooms~~ Completed (basic functionality done)
7. Read-only developer JSON REST API
8. ~~Developer access to the websocket interface to allow write access to 3rd party applications~~ Completed
