# frozen_string_literal: true

require "rails_helper"

RSpec.describe Role, type: :model do
  include_context "with mocked services"

  describe "validations" do
    subject(:role) { build(:role) }

    it { is_expected.to validate_uniqueness_of(:ability).scoped_to(:team_id, :user_id) }
    it { is_expected.to allow_value(mocked_user_id).for(:user_id) }
    it { is_expected.not_to allow_value("12345678").for(:user_id) }
    it { is_expected.to allow_value("12345678-abcd-1234-dcba-123456789abc").for(:team_id) }
    it { is_expected.not_to allow_value("12345678").for(:team_id) }

    # References: https://thoughtbot.com/blog/enum-validations-and-database-constraints-in-rails-7-1
    it {
      expect(role).to define_enum_for(:ability).with_values(
        {
          developer: "Developer", product_owner: "Product Owner", tester: "Tester"
        }
      ).backed_by_column_of_type(:enum)
    }

    describe "check_team_existence" do
      context "with a team found" do
        it "is expected to be valid" do
          expect(described_class.new(user_id: mocked_user_id, team_id: mocked_team_id)).to be_valid
        end
      end

      context "with a team not found" do
        before { allow(UsersOfTeamService).to receive(:call).and_return(nil) }

        it "is expected to not be valid" do
          expect(described_class.new(user_id: mocked_user_id, team_id: Faker::Internet.uuid)).not_to be_valid
        end
      end

      context "with a user that does not belong to the team" do
        it "is expected to not be valid" do
          expect(described_class.new(user_id: Faker::Internet.uuid, team_id: mocked_team_id)).not_to be_valid
        end
      end
    end
  end
end
