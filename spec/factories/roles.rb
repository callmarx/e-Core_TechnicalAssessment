# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    team_id { Faker::Internet.uuid }
    user_id { Faker::Internet.uuid }
    ability { ["Developer", "Product Owner", "Tester"].sample }

    factory :role_skips_validate do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
