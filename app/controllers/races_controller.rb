class RacesController < ApplicationController
  def index
    @races = Race.includes(:game, :category).active.order(status_text: :desc)
  end

  def show
    @race = Race.includes(:game, :category, :entrants, :users).find(params[:id])
    gon.race = @race
  end

  def completed
    @races = Race.includes(:game, :category).completed.order(finish_time: :desc).page(params[:page])
  end
end
