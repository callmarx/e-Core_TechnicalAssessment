# frozen_string_literal: true

require "rails_helper"

RSpec.describe Role, type: :model do
  describe "validations" do
    subject { build(:role) }

    it { is_expected.to validate_uniqueness_of(:ability).scoped_to(:team_id, :user_id) }

    # References: https://thoughtbot.com/blog/enum-validations-and-database-constraints-in-rails-7-1
    it {
      expect(subject).to define_enum_for(:ability).with_values(
        {
          developer: "Developer", product_owner: "Product Owner", tester: "Tester"
        }
      ).backed_by_column_of_type(:enum)
    }
  end
end
