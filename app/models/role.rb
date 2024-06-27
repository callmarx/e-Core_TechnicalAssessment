# frozen_string_literal: true

class Role < ApplicationRecord
  validates :ability, uniqueness: { scope: %i[team_id user_id] }
  enum :ability, { developer: "Developer", product_owner: "Product Owner", tester: "Tester" }, validate: true
end
