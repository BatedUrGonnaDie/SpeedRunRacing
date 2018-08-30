class Api::V1::TimeController < Api::V1::ApplicationController
  def create
    render status: :ok, json: {
      status: :ok,
      id: params[:id],
      result: Time.now.utc.to_f * 1000
    }
  end
end
