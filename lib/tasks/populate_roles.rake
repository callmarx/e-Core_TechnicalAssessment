# frozen_string_literal: true

namespace :db do
  desc "Populate the database with valid roles from external API"
  task populate_roles: [:environment] do
    if Rails.env.production?
      puts "This task cannot be run in the production environment."
      exit
    end

    begin
      puts("\nThis task can take a few seconds to be performed, please waiting...\n\n")
      puts("# Fetching teams from the external API")
      teams_response = HTTParty.get(ExternalDataService::API_URL_TEAMS, headers: ExternalDataService::HEADERS)
      raise("# ↪ Error fetching teams") unless teams_response.success?

      teams = JSON.parse(teams_response.body)
      roles_created = 0
      max_roles = 10

      puts("# ↪ Trying to create 10 random roles")
      teams.each do |team|
        break if roles_created >= max_roles

        team_id = team["id"]

        puts("#   ↪ Fetching users of the team_id [#{team_id}] using UsersOfTeamService")
        user_ids = UsersOfTeamService.call(team_id)
        next unless user_ids

        user_ids.each do |user_id|
          break if roles_created >= max_roles

          puts("#    ↪ Check if the user [#{user_id}] exists using UserCheckService")
          next unless UserCheckService.call(user_id)

          ability = Role.abilities.keys.sample

          begin
            puts("#       ↪ Trying to create a new role with a randon ability")
            Role.create!(team_id: team_id, user_id: user_id, ability: ability)
            roles_created += 1
          rescue ActiveRecord::RecordInvalid => e
            puts("#       ↪ Skipping role creation due to validation error: #{e.message}")
          end
        end
      end

      puts("# ↪ Database populated with up to #{roles_created} valid roles from external API.")
    rescue StandardError => e
      puts("# ↪ Error populating database: #{e.message}")
    end
  end
end
