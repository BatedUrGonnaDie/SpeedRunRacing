class SearchController < ApplicationController
  def index
    if params[:q].present?
      @games = Game.search(params[:q])
      @users = User.search(params[:q])
    else
      @games = Game.none
      @users = User.none
    end
  end
end
