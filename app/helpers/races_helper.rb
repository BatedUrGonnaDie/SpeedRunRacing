module RacesHelper
  def race_color(race)
    if race.status_text == Race::OPEN
      'text-success'
    elsif race.status_text == Race::PROGRESS
      'text-warning'
    elsif race.status_text == Race::ENDED
      'text-danger'
    else
      raise
    end
  end
end
