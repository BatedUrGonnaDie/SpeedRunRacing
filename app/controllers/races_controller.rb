class RacesController < ApplicationController
  def index
    @races = Race.includes(:game, :category).active.order(status_text: :desc)
  end

  def show
    @race = Race.includes(:game, :category, :entrants, :users).find(params[:id])

    if @race.present?
      @chat_messages = @race.chat_messages.includes(:user)
      gon.race = @race
      gon.chat_room = @race.chat_room
    else
      @error = {resource: 'race', name: params[:id]}
      render 'shared/not_found'
      return
    end
  end

  def completed
    @races = Race.includes(:game, :category).completed.order(finish_time: :desc).page(params[:page])
  end
end
