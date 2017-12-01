class Api::V1::TimeController < Api::V1::ApplicationController
  def create
    render json: {
      status: 200,
      id: params[:id],
      result: Time.now.to_f * 1000
    }
  end
end
