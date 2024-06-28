# frozen_string_literal: true

RSpec.shared_context "with mocked services" do
  before do
    # rubocop:disable RSpec/InstanceVariable
    @team_id = Faker::Internet.uuid
    @user_id = Faker::Internet.uuid

    allow(UserCheckService).to receive(:call).and_return(true)
    allow(UsersOfTeamService).to receive(:call).and_return([@user_id])
    # rubocop:enable RSpec/InstanceVariable
  end
end
