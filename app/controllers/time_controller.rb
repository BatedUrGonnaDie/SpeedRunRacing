class TimeController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :set_current_user

  def timesync
    render 200, json: {
      id: params[:id],
      result: DateTime.now.to_f * 1000
    }
  end
end
