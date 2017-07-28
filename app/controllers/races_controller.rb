class RacesController < ApplicationController

  def index
    @races = Race.active
  end

end
