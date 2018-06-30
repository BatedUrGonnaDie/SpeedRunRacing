class GamesController < ApplicationController
  def index
    @games = Game.page(params[:page]).order(:name)
  end

  def show
    @game = Game.includes(:categories, :races).find_by(shortname: params[:id])

    return unless @game.nil?

    @error = {resource: 'game shortname', name: params[:id]}
    render 'shared/not_found'
  end

  def autocomplete
    render json: Game.where('name ILIKE ?', "%#{params[:query]}%")
  end
end
