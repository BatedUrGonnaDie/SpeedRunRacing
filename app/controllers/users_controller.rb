class UsersController < ApplicationController
  def index
    @user = User.includes(:races).find_by(username: params[:username])
  end
end
