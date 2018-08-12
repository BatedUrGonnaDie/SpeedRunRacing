class RacesController < ApplicationController
  before_action :set_race, only: [:show]

  def index
    @races = Race.includes(:game, :category).active.order(status_text: :desc)
  end

  def show
    @chat_room = @race.chat_room
    @chat_messages = @race.chat_messages.includes(:user)
    gon.race = @race
    gon.chat_room = @race.chat_room
  end

  def completed
    @races = Race.includes(:game, :category).completed.order(finish_time: :desc).page(params[:page])
  end

  private

  def set_race
    @race = Race.includes(:game, :category, :entrants, :users).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @error = {resource: 'race', name: params[:id]}
    render 'shared/not_found'
  end
end
