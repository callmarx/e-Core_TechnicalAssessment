# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render404

  def render404
    render(status: :not_found, json: { error: "Entity not found" })
  end
end
