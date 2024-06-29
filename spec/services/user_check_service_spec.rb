# frozen_string_literal: true

require "rails_helper"
require "webmock/rspec"

RSpec.describe UserCheckService do
  let(:uuid) { Faker::Internet.uuid }
  let(:service) { described_class.new(uuid) }
  let(:api_url) { "#{ExternalDataService::API_URL_USERS}/#{uuid}" }
  let(:headers) { ExternalDataService::HEADERS }

  describe "#call" do
    context "when the user exists" do
      before do
        stub_request(:get, api_url).with(headers: headers).to_return(status: 200, body: "{\"id\": \"#{uuid}\"}")
      end

      it "returns true" do
        expect(service.call).to be_truthy
      end
    end

    context "when the user does not exist" do
      before do
        stub_request(:get, api_url).with(headers: headers).to_return(status: 200, body: "null")
      end

      it "returns false" do
        expect(service.call).to be_falsey
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
