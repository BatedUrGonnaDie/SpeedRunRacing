class UsersController < ApplicationController
  def index
    @user = User.find_by(username: params[:user])
  end
end
