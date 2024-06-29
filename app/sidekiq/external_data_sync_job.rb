# frozen_string_literal: true

class ExternalDataSyncJob
  include Sidekiq::Job

  def perform
    Role.find_each do |role|
      role.destroy unless user_checked?(role.user_id) && team_checked?(role.team_id, role.user_id)
    end
  end

  private
    def user_checked?(user_id)
      UserCheckService.call(user_id)
    end

    def team_checked?(team_id, user_id)
      users = UsersOfTeamService.call(team_id)
      users&.include?(user_id)
    end
end
