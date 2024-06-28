# frozen_string_literal: true

class Role < ApplicationRecord
  validates :ability, uniqueness: { scope: %i[team_id user_id] }
  validates :team_id, :user_id, format: { with: /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/ }
  enum :ability,
       { developer: "Developer", product_owner: "Product Owner", tester: "Tester" },
       default: :developer,
       validate: true

  validate :check_team_existence, :check_user_existence

  private
    def check_user_existence
      return unless user_id

      errors.add(:user_id, "User not found") unless UserCheckService.call(user_id)
    end

    def check_team_existence
      return unless team_id

      users = UsersOfTeamService.call(team_id)
      if !users
        errors.add(:team_id, "Team not found")
      elsif users.exclude?(user_id)
        errors.add(:user_id, "User doesn't belong to the team")
      end
    end
end
