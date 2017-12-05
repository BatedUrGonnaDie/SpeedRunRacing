# SpeedRunRacing

A modern racing website for speedrunners to compete against eachother.

# Development

### Requirements
- Ruby 2.4.2
- Postgres
- Node/Yarn

### Setup
1. `cp config/application.example.yml config/application.yml`
2. Fill out any variables in there
3. `bundle install`
4. `yarn install`
5. `rake db:migrate`

# Goals

1. ~~Full user login, with the ability to link twitch accounts~~ Completed
2. ~~Race coordinator~~ Completed
3. ~~Websocket server that connects users to coordinator to allow native
in browser racing~~ Completed
4. ~~Better handling of errors from the server~~ Completed
5. Finish last pages that have holes in them
6. ~~Chat rooms and messages for race rooms~~ Completed (basic functionality done)
7. Read-only developer JSON REST API
8. Developer access to the websocket interface to allow write access to 3rd party applications

dump from tests
add x in time column on forfeits
sort entrants table by place (FF anchor bottom) (completed in ruby already)
easier to create races
create race form
