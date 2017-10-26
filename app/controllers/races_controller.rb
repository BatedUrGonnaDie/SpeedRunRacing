class RacesController < ApplicationController
  def index
    @races = []
  end

  def create
    @race = Race.new(race_params)
    puts @race.inspect
  end

  def show
    # TODO: Add include for game, category, and entraints
    @race = Race.find(params[:id])
  end

  def update
  end

  private

  def race_params
    params.permit(:category)
  end
end
