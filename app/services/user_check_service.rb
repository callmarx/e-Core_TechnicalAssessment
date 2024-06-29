# frozen_string_literal: true

class UserCheckService < ExternalDataService
  def call
    response = HTTParty.get("#{API_URL_USERS}/#{@uuid}", headers: HEADERS)
    raise(ExternalApiError, "External API Error => #{response}") unless response.success?

    # NOTE: Since there are no useful information on this retrive, this obly will used to chech if the user exists
    response.body != "null"
  end
end
