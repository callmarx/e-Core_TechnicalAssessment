# frozen_string_literal: true

class ExternalDataService
  API_URL_TEAMS = ENV.fetch("API_URL_TEAMS", "https://cgjresszgg.execute-api.eu-west-1.amazonaws.com/teams")
  API_URL_USERS = ENV.fetch("API_URL_USERS", "https://cgjresszgg.execute-api.eu-west-1.amazonaws.com/users")
  HEADERS = { "Content-Type" => "application/json" }.freeze

  def self.call(*args, &block)
    new(*args, &block).call
  end

  def initialize(uuid)
    @uuid = uuid
  end
end
