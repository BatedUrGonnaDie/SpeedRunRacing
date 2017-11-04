class RacesController < ApplicationController
  def index
    @races = Race.active
  end

  def show
    @race = Race.includes(:game, :category, :entrants).find(params[:id])
    gon.race_id = @race.id
  end

  def completed
    @races = Race.completed
  end
end
