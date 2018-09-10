class Api::V1::UsersController < Api::V1::ApplicationController
  before_action :set_user, only: [:show, :races]
  before_action :set_race_type, only: [:races]
  before_action :set_races, only: [:races]

  def show
    render json: @user,
           serializer: Api::V1::UserSerializer,
           adapter: :json
  end

  def races
    paginate json: @races,
             each_serializer: Api::V1::RaceSerializer,
             adapter: :json,
             include: ['entrants', 'entrants.user', 'game', 'category']
  end

  private

  def set_race_type
    @race_type = params[:race_status].try(:downcase) || 'completed'
    return if Race::VALID_API_PARAMS.include?(@race_type)

    render status: :bad_request, json: {
      status: :bad_request,
      error: "Invalid race type, please supply on of the following: #{Race::VALID_API_PARAMS}"
    }
  end

  def set_user
    @user = User.find_by!(username: params[:username])
  rescue ActiveRecord::RecordNotFound
    not_found('user', :username)
  end

  def set_races
    @races = @user.races.includes(:game, :category, entrants: [:user]).newest
    case @race_type
    when 'completed'
      @races = @races.completed
    when 'active'
      @races = @races.active
    end
  end
end
