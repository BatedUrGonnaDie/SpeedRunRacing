class GamesController < ApplicationController
  def index
    @games = Game.page(params[:page]).order(:name)
  end

  def show
    @game = Game.includes(:categories, :races).find_by!(shortname: params[:id])
  end

  def autocomplete
    render json: Game.where('name ILIKE ?', "%#{params[:query]}%")
  end
end
