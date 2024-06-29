# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalDataService do
  subject(:external_data_service) { described_class.new(uuid) }

  let(:uuid) { Faker::Internet.uuid }

  describe "#initialize" do
    it "sets the uuid" do
      expect(external_data_service.instance_variable_get(:@uuid)).to eq(uuid)
    end
  end

  describe ".call" do
    let(:service_class) { class_double(described_class) }

    before do
      allow(described_class).to receive(:new).with(uuid).and_return(service_class)
      allow(service_class).to receive(:call)
      described_class.call(uuid)
    end

    it "creates a new instance and calls #call" do
      expect(described_class).to have_received(:new).with(uuid)
      expect(service_class).to have_received(:call)
    end
  end
end
