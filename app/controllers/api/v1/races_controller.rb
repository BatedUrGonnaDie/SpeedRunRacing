class Api::V1::RacesController < Api::V1::ApplicationController
  before_action :set_race, only: [:show]

  def index
    race_types = params[:race_status] || 'active'

    case race_types
    when 'completed'
      @races = Race.completed
      paginate json: @races, serializer: Api::V1::RaceSerializer
    when 'active'
      @races = Race.active
      render json: @races, serializer: Api::V1::RaceSerializer
    end
  end

  def show
    render json: @race, serializer: Api::V1::RaceSerializer
  end

  private

  def set_race
    @race = Race.find(params[:race_id])

    return if @race.present?

    not_found('race', :race_id)
  end
end
