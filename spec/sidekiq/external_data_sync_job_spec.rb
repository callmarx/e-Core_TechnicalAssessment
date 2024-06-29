# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ExternalDataSyncJob, type: :job do
  let!(:existing_team_id) { Faker::Internet.uuid }
  let!(:existing_user_id) { Faker::Internet.uuid }
  let!(:existing_unlinked_user_id) { Faker::Internet.uuid }
  let!(:non_existing_team_id) { Faker::Internet.uuid }
  let!(:non_existing_user_id) { Faker::Internet.uuid }
  let!(:role_existing) { create(:role_skips_validate, user_id: existing_user_id, team_id: existing_team_id) }
  let!(:role_non_existing_user) do
    create(:role_skips_validate, user_id: non_existing_user_id, team_id: existing_team_id)
  end
  let!(:role_non_existing_team) do
    create(:role_skips_validate, user_id: existing_user_id, team_id: non_existing_team_id)
  end
  let!(:role_unlinked_user) do
    create(:role_skips_validate, user_id: existing_unlinked_user_id, team_id: existing_team_id)
  end

  before do
    allow(UserCheckService).to receive(:call).with(existing_user_id).and_return(true)
    allow(UserCheckService).to receive(:call).with(existing_unlinked_user_id).and_return(true)
    allow(UserCheckService).to receive(:call).with(non_existing_user_id).and_return(false)
    allow(UsersOfTeamService).to receive(:call).with(existing_team_id).and_return([existing_user_id])
    allow(UsersOfTeamService).to receive(:call).with(non_existing_team_id).and_return(nil)
    Sidekiq::Testing.inline! do
      described_class.perform_async
    end
  end

  describe "#perform" do
    context "when user and team exist" do
      it "keeps the role" do
        expect(Role).to exist(role_existing.id)
      end
    end

    context "when user does not exist" do
      it "destroys the role" do
        expect(Role).not_to exist(role_non_existing_user.id)
      end
    end

    context "when team does not exist" do
      it "destroys the role" do
        expect(Role).not_to exist(role_non_existing_team.id)
      end
    end

    context "when user does not belong to the team" do
      it "destroys the role" do
        expect(Role).not_to exist(role_unlinked_user.id)
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
