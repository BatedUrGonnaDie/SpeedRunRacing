class GamesController < ApplicationController
  def autocomplete
    render json: Game.where('name ILIKE ?', "%#{params[:query]}%")
  end
end
