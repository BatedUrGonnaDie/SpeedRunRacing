class Api::V1::ApplicationController < ActionController::API
  # include Rails::Pagination

  before_action :force_ssl, if: -> { Rails.env.production? }

  private

  def force_ssl
    render status: 301, json: {status: 301, error: "HTTPS is required to access SRR's API."} unless request.ssl?
  end
end
