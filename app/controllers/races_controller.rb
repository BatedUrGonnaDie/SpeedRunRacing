class RacesController < ApplicationController
  def index
    @races = Race.active
  end

  def show
    @race = Race.includes(:game, :category, :entrants, :users).find(params[:id])
    gon.race = @race
  end

  def completed
    @races = Race.completed
  end
end
