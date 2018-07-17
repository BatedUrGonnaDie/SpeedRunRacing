class Api::V1::RacesController < Api::V1::ApplicationController
  before_action :set_race_type, only: [:index]
  before_action :set_race, only: [:show]

  def index
    case @race_types
    when 'completed'
      @races = Race.completed
    when 'active'
      @races = Race.active
    end

    render json: @races,
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
    valid_types = %w[completed active]
    @race_types = params[:race_status].try(:downcase) || 'active'
    return if valid_types.include?(@race_types)

    render status: :bad_request, json: {
      status: 400,
      error: "Invalid race type, please supply on of the following: #{valid_types}"
    }
  end

  def set_race
    @race = Race.includes(:game, :category, :entrants).find(params[:race_id])
  rescue ActiveRecord::RecordNotFound
    not_found('race', :race_id)
  end
end
