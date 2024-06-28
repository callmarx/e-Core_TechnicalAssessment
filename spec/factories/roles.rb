# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    team_id { Faker::Internet.uuid }
    user_id { Faker::Internet.uuid }
    ability { ["Developer", "Product Owner", "Tester"].sample }
  end
end
