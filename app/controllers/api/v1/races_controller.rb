class Api::V1::RacesController < Api::V1::ApplicationController
  before_action :set_race_type, only: [:index]
  before_action :set_race, only: [:show]
  before_action :set_races, only: [:index]

  def index
    paginate json: @races,
             each_serializer: Api::V1::RaceSerializer,
             adapter: :json,
             include: ['entrants', 'entrants.user', 'game', 'category']
  end

  def show
    render json: @race,
           serializer: Api::V1::RaceSerializer,
           adapter: :json,
           include: ['entrants', 'entrants.user', 'game', 'category']
  end

  private

  def set_race_type
    @race_type = params[:race_status].try(:downcase) || 'active'
    return if Race::VALID_API_PARAMS.include?(@race_type)

    render status: :bad_request, json: {
      status: :bad_request,
      error: "Invalid race type, please supply on of the following: #{Race::VALID_API_PARAMS}"
    }
  end

  def set_races
    @races = Race.includes(:game, :category, entrants: [:user]).newest
    case @race_type
    when 'completed'
      @races = @races.completed
    when 'active'
      @races = @races.active
    end
  end

  def set_race
    @race = Race.includes(:game, :category, entrants: [:user]).find(params[:race_id])
  rescue ActiveRecord::RecordNotFound
    not_found('race', :race_id)
  end
end
