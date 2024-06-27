# frozen_string_literal: true

require "rails_helper"

RSpec.describe RolesController, type: :routing do
  describe "routing" do
    let(:role) { create(:role) }

    it "routes to #index" do
      expect(get: "/roles").to route_to("roles#index")
    end

    it "routes to #index_by_team" do
      expect(get: "/roles/team/#{role.team_id}").to route_to("roles#index_by_team", team_id: role.team_id)
    end

    it "routes to #index_by_user" do
      expect(get: "/roles/user/#{role.user_id}").to route_to("roles#index_by_user", user_id: role.user_id)
    end

    it "routes to #index_by_ability" do
      expect(get: "/roles/ability/#{role.ability}").to route_to("roles#index_by_ability", ability: role.ability)
    end

    it "routes to #show" do
      expect(get: "/roles/#{role.id}").to route_to("roles#show", id: role.id.to_s)
    end

    it "routes to #show_by_team_and_user" do
      expect(get: "/roles/membership/#{role.team_id}/#{role.user_id}").to route_to(
        "roles#show_by_team_and_user",
        team_id: role.team_id,
        user_id: role.user_id
      )
    end

    it "routes to #create" do
      expect(post: "/roles").to route_to("roles#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/roles/#{role.id}").to route_to("roles#update", id: role.id.to_s)
    end

    it "routes to #update via PATCH" do
      expect(patch: "/roles/#{role.id}").to route_to("roles#update", id: role.id.to_s)
    end

    it "routes to #destroy" do
      expect(delete: "/roles/#{role.id}").to route_to("roles#destroy", id: role.id.to_s)
    end
  end
end
