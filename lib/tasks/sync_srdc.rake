# This is extremely slow, and will sync every single game and category to SRDC
# This should only be ran at most once per week
# If you just need one game synced, please use the sync_game task

require 'httparty'

SRDC_URL = 'https://www.speedrun.com/api/v1/games?embed=categories&max=200'.freeze

desc 'Sync all games/categories to srdc'
task sync_srdc: [:environment] do
  request_count = 0
  refresh_time = Time.now.utc
  url = SRDC_URL

  loop do
    puts url
    games = HTTParty.get(url, headers: {'User-Agent' => 'SRRSyncBot/1.0'})
    break if games['data'].empty?

    games['data'].each do |game|
      g = Game.find_or_initialize_by(srdc_id: game['id'])
      g.update(
        srdc_id: game['id'],
        shortname: game['abbreviation'],
        name: game['names']['international'],
        weblink: game['weblink'],
        cover_small: game['assets']['cover-small']['uri'],
        cover_large: game['assets']['cover-large']['uri']
      )
      g.save

      game['categories']['data'].each do |category|
        c = Category.find_or_initialize_by(srdc_id: category['id'], game: g)
        c.update(
          srdc_id: category['id'],
          name: category['name'],
          weblink: category['weblink']
        )
        c.save
      end
    end

    request_count += 1
    new_time = Time.now.utc
    if request_count >= 90
      st = (new_time + 1.minute) - refresh_time
      puts "Sleeping for #{st} seconds"
      sleep st
    end

    if (new_time - refresh_time) >= 1.minute
      refresh_time = new_time
      request_count = 0
    end

    old_url = url
    games['pagination']['links'].each do |l|
      if l['rel'] == 'next'
        url = l['uri']
        break
      end
    end
    break if old_url == url
  end
end
