class TwitchController < ApplicationController
  before_action :authenticate_user!

  def create
    auth = request.env['omniauth.auth']

    if update_user(auth)
      redirect_to root_path, notice: "Successfully linked Twitch account: #{auth.info.nickname}!"
    else
      redirect_to root_path, alert: "Error: #{user.errors.full_messages.join(', ')}."
    end
  end

  def failure
    redirect_to redirect_path, alert: "Error: #{params[:message]}"
  end

  private

  def update_user(auth)
    user = current_user

    user.update(
      twitch_name: auth.info.nickname,
      twitch_display_name: auth.info.name,
      twitch_id: auth.uid,
      twitch_email: auth.email
    )
  end
end
