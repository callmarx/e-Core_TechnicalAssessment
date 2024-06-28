# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404
    render(status: :not_found, json: { error: "Entity not found" })
  end
end
