# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
games = Game.create([
  {name: 'Super Mario Sunshine', shortname: 'sms',
    weblink: 'https://www.speedrun.com/sms', cover_large: 'https://www.speedrun.com/themes/sms/cover-256.png',
    cover_small: 'https://www.speedrun.com/themes/sms/cover-32.png'}
])

Category.create([
  {name: 'Any%', game: games.first, weblink: 'https://www.speedrun.com/sms#Any%'},
  {name: '120 Shines', game: games.first, weblink: 'https://www.speedrun.com/sms#120_Shines'}
])

Entrant.create([
  {user_id: 1, game_id: 1}
])
