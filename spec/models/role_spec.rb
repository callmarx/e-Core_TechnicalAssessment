# frozen_string_literal: true

require "rails_helper"

RSpec.describe Role, type: :model do
  include_context "with mocked services"

  describe "validations" do
    subject(:role) { build(:role) }

    it { is_expected.to validate_uniqueness_of(:ability).scoped_to(:team_id, :user_id) }
    it { is_expected.to allow_value("12345678-abcd-1234-dcba-123456789abc").for(:user_id) }
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
  end
end
