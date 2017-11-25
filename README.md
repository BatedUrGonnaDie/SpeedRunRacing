# SpeedRunRacing

A modern racing website for speedrunners to compete against eachother.

# Development

- Ruby 2.4.2
- Postgres

Fill out the application.example.yml in the config folder and rename
to application.yml.  Run any pending migrations and you are good to go.

# Goals

1. ~~Full user login, with the ability to link twitch accounts~~ Completed
2. ~~Race coordinator~~ Completed
3. ~~Websocket server that connects users to coordinator to allow native
in browser racing~~ Completed
4. Better handling of errors from the server
5. Read-only developer JSON REST API
6. Developer access to the websocket interface to allow write access to 3rd party applications
