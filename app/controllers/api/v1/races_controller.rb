class Api::V1::RacesController < Api::V1::ApplicationController
  before_action :set_race, only: [:show]

  def index
    race_types = params[:race_status] || 'active'

    case race_types
    when 'completed'
      @races = Race.completed
      paginate json: @races,
               serializer: Api::V1::RaceSerializer,
               adapter: :json,
               include: ['entrants', 'entrants.user', 'game', 'category']
    when 'active'
      @races = Race.active
      render json: @races,
             serializer: Api::V1::RaceSerializer,
             adapter: :json,
             include: ['entrants', 'entrants.user', 'game', 'category']
    end
  end

  def show
    render json: @race,
           serializer: Api::V1::RaceSerializer,
           adapter: :json,
           include: ['entrants', 'entrants.user', 'game', 'category']
  end

  private

  def set_race
    @race = Race.includes(:game, :category, :entrants).find(params[:race_id])
  rescue ActiveRecord::RecordNotFound
    not_found('race', :race_id)
  end
end
