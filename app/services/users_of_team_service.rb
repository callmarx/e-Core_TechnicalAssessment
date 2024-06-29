# frozen_string_literal: true

class UsersOfTeamService < ExternalDataService
  def call
    response = HTTParty.get("#{API_URL_TEAMS}/#{@uuid}", headers: HEADERS)
    raise(ExternalApiError, "External API Error => #{response}") unless response.success?
    return if response.body == "null"

    parse_team(response)
  end

  private
    def parse_team(response)
      result = JSON.parse(response.body)
      result["teamMemberIds"].push(result["teamLeadId"])
    end
end
