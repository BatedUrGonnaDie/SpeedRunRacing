class Api::V1::ApplicationController < ActionController::API
  before_action :force_ssl, if: -> { Rails.env.production? }

  def not_found(resource, param_name)
    render status: :not_found, json: {
      status: 404,
      error: "No #{resource} found for ID #{params[param_name]}"
    }
  end

  private

  def force_ssl
    return if request.ssl?

    secure_uri = URI.parse(request.original_url)
    secure_uri.scheme = 'https'
    response.set_header('Location', secure_uri.to_s)

    render status: :moved_permanently, json: {
      status: 301,
      error: "HTTPS is required to access SRR's API.",
      location: secure_uri
    }
  end
end
