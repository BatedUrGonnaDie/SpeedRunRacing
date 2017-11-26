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

  def iso_time_string(field)
    field.try(:to_formatted_s, :iso8601)
  end

  def race_table_locals(table_type, races)
    case table_type
    when :active_races
      {
        races: races,
        cols: %i[cover game_cat entrants status_text duration],
        description: 'Active Races'
      }
    when :completed_races
      {
        races: races,
        cols: %i[cover game_cat entrants duration finished],
        description: 'Completed Races'
      }.merge(sorting_info)
    end
  end

  private

  def sorting_info
    {
      page: params[:page] || 1
    }
  end
end
