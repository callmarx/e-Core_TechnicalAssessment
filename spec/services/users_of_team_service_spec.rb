# frozen_string_literal: true

require "rails_helper"
require "webmock/rspec"

RSpec.describe UsersOfTeamService do
  let(:uuid) { Faker::Internet.uuid }
  let(:service) { described_class.new(uuid) }
  let(:api_url) { "#{ExternalDataService::API_URL_TEAMS}/#{uuid}" }
  let(:headers) { ExternalDataService::HEADERS }

  describe "#call" do
    context "when the team exists" do
      let(:response_body) do
        { "id" => uuid, "teamLeadId" => "lead-uuid", "teamMemberIds" => ["member-1-uuid", "member-2-uuid"] }.to_json
      end

      before do
        stub_request(:get, api_url).with(headers: headers).to_return(status: 200, body: response_body)
      end

      it "returns an array of user IDs including the team lead" do
        result = service.call
        expect(result).to contain_exactly("member-1-uuid", "member-2-uuid", "lead-uuid")
      end
    end

    context "when the team does not exist" do
      before do
        stub_request(:get, api_url).with(headers: headers).to_return(status: 200, body: "null")
      end

      it "returns nil" do
        expect(service.call).to be_nil
      end
    end

    context "when the API request fails" do
      before do
        stub_request(:get, api_url).with(headers: headers).to_return(status: 500, body: "Internal Server Error")
      end

      it "raises an ExternalApiError" do
        expect { service.call }.to raise_error(ExternalApiError, /External API Error/)
      end
    end
  end
end
