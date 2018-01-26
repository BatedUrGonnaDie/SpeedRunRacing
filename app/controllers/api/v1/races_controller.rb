class Api::V1::RacesController < Api::V1::ApplicationController
  def index
    params.require(:race_status)
    if params[:race_status] == 'completed'
      @races = Race.completed
    elsif params[:race_status] == 'active'
      @races = Race.active
    end
    render json: @races, serializer: Api::V1::RaceSerializer
  end
end
