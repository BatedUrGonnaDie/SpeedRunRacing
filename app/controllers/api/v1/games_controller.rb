class Api::V1::GamesController < Api::V1::ApplicationController
  before_action :set_game, only: [:show, :races]
  before_action :set_race_type, only: [:races]
  before_action :set_races, only: [:races]

  def index
    if params[:q].blank?
      render status: :bad_request, json: {status: :bad_request, message: '"q" parameter is required.'}
      return
    end
    @games = Game.includes(:categories).search(params[:q])
    paginate json: @games,
             each_serializer: Api::V1::GameSerializer,
             adapter: :json,
             include: ['categories']
  end

  def show
    render json: @game,
           serializer: Api::V1::GameSerializer,
           adapter: :json,
           include: ['categories']
  end

  def races
    paginate json: @races,
             each_serializer: Api::V1::RaceSerializer,
             adapter: :json,
             include: ['entrants', 'entrants.user', 'game', 'category']
  end

  private

  def set_game
    @game = Game.find_by!(shortname: params[:shortname])
  rescue ActiveRecord::RecordNotFound
    not_found('game', :shortname)
  end

  def set_race_type
    @race_type = params[:race_status].try(:downcase) || 'combined'
    return if Race::VALID_API_PARAMS.include?(@race_type)

    render status: :bad_request, json: {
      status: :bad_request,
      error: "Invalid race type, please supply on of the following: #{Race::VALID_API_PARAMS}"
    }
  end

  def set_races
    @races = Race.includes(:game, :category, entrants: [:user]).by_game(@game).newest
    case @race_type
    when 'completed'
      @races = @races.completed
    when 'active'
      @races = @races.active
    end
  end
end
