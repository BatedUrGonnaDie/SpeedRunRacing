class RacesController < ApplicationController
  def index
    @races = Race.active
  end

  def create
    @category = Category.find(params[:race][:category_id])
    @race = Race.new(category: @category)
    if @race.save
      redirect_to race_path(@race)
    else
      flash[:danger] = "Error creating race: #{@race.errors.full_messages.join(', ')}."
    end
  end

  def show
    @race = Race.includes(:game, :category).find(params[:id])
  end

  def update
  end
end
