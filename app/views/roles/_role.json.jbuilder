# frozen_string_literal: true

json.extract!(role, :id, :team_id, :user_id, :ability, :created_at, :updated_at)
json.url(role_url(role, format: :json))
