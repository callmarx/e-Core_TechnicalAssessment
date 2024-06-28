# frozen_string_literal: true

RSpec.shared_context "with mocked services" do
  let(:mocked_team_id) { Faker::Internet.uuid }
  let(:mocked_user_id) { Faker::Internet.uuid }

  before do
    allow(UserCheckService).to receive(:call).and_return(true)
    allow(UsersOfTeamService).to receive(:call).and_return([mocked_user_id])
  end
end
