class Api::V1::Games::CategoriesController < Api::V1::ApplicationController
  before_action :set_game, only: [:races]
  before_action :set_category, only: [:races]
  before_action :set_races, only: [:races]

  def races
    paginate json: @races,
             each_serializer: Api::V1::RaceSerializer,
             adapter: :json,
             include: ['entrants', 'entrants.user', 'game', 'category']
  end

  private

  def set_game
    @game = Game.find_by!(shortname: params[:shortname])
  rescue ActiveRecord::RecordNotFound
    not_found('game', :shortname)
  end

  def set_category
    @category = Category.find_by!(id: params[:category_id], game: @game)
  rescue ActiveRecord::RecordNotFound
    not_found('category', :category_id)
  end

  def set_races
    @races = Race.includes(:game, :category, entrants: [:user]).by_cat(@category)
    not_found('category', :category_id) if @races.blank?
  end
end
