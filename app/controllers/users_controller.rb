class UsersController < ApplicationController
  def index
    @user = User.includes(:races).find_by(username: params[:username])

    return unless @user.nil?

    @error = {resource: 'user', name: params[:username]}
    render 'shared/not_found'
  end
end
