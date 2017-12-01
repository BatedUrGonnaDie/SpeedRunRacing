class Api::V1::ApplicationController < ActionController::Base
  # include Rails::Pagination

  before_action :force_ssl, if: -> { Rails.env.production? }

  private

  def force_ssl
    render status: 301, json: {status: 301, error: "SSL is required to access SRR's API."} unless request.ssl?
  end
end
