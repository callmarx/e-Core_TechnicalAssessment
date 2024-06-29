# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render404
  rescue_from ExternalApiError, with: :render_api_error

  def render404
    render(status: :not_found, json: { error: "Entity not found" })
  end

  def render_api_error(exception)
    render(status: :service_unavailable, json: { error: exception })
  end
end
