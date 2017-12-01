class SearchController < ApplicationController
  def search
    if params[:q].present?
      @games = Game.basic_search(params[:q])
      @users = User.basic_search(params[:q])
    else
      @games = []
      @users = []
    end
  end
end
