# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/roles", type: :request do
  include_context "with mocked services"

  let(:valid_headers) do
    { "Content-Type": "application/json" }
  end

  describe "GET requests" do
    let(:role) { create(:role, user_id: mocked_user_id, team_id: mocked_team_id) }

    describe "GET /roles => roles#index" do
      before { get roles_url, headers: valid_headers, as: :json }

      it "renders a JSON response with the roles" do
        expect(response).to have_http_status(:ok)
        expect(response).to match_json_schema("roles")
      end
    end

    describe "GET /roles/team/:team_id => roles#index_by_team" do
      before { get roles_by_team_url(team_id: role.team_id), headers: valid_headers, as: :json }

      it "renders a JSON response with the roles" do
        expect(response).to have_http_status(:ok)
        expect(response).to match_json_schema("roles")
      end
    end

    describe "GET /roles/user/:user_id => roles#index_by_user" do
      before { get roles_by_user_url(user_id: role.user_id), headers: valid_headers, as: :json }

      it "renders a JSON response with the roles" do
        expect(response).to have_http_status(:ok)
        expect(response).to match_json_schema("roles")
      end
    end

    describe "GET /roles/ability/:ability => roles#index_by_ability" do
      context "with valid parameters" do
        it "renders a JSON response with the roles" do
          get roles_by_ability_url(ability: role.ability), headers: valid_headers, as: :json
          expect(response).to have_http_status(:ok)
          expect(response).to match_json_schema("roles")
        end
      end

      context "with invalid parameters" do
        it "renders a JSON response with error" do
          get roles_by_ability_url(ability: "invalid"), headers: valid_headers, as: :json
          parsed_body = response.parsed_body
          expect(response).to have_http_status(:bad_request)
          expect(parsed_body).to include({ "error" => "'invalid' is not a valid ability" })
        end
      end
    end

    describe "GET /roles/:id => roles#show" do
      context "with valid parameters" do
        it "renders a JSON response with the role" do
          get role_url(role), headers: valid_headers, as: :json
          expect(response).to have_http_status(:ok)
          expect(response).to match_json_schema("role")
        end
      end

      context "with invalid parameters" do
        it "renders a JSON response with error" do
          get role_url(role.id + 1), headers: valid_headers, as: :json
          parsed_body = response.parsed_body
          expect(response).to have_http_status(:not_found)
          expect(parsed_body).to include({ "error" => "Entity not found" })
        end
      end
    end

    describe "GET /roles/membership/:team_id/:user_id => roles#show_by_team_user" do
      context "with valid parameters" do
        it "renders a JSON response with the role" do
          get role_by_team_and_user_url(user_id: role.user_id, team_id: role.team_id), headers: valid_headers, as: :json
          expect(response).to have_http_status(:ok)
          expect(response).to match_json_schema("role")
        end
      end

      context "with invalid parameters" do
        it "renders a JSON response with error" do
          get role_by_team_and_user_url(user_id: "invalid", team_id: "invalid"), headers: valid_headers, as: :json
          parsed_body = response.parsed_body
          expect(response).to have_http_status(:not_found)
          expect(parsed_body).to include({ "error" => "Entity not found" })
        end
      end
    end
  end

  describe "POST/DELETE requests" do
    let!(:valid_attributes) do
      {
        team_id: Faker::Internet.uuid,
        user_id: Faker::Internet.uuid,
        ability: ["Developer", "Product Owner", "Tester"].sample
      }
    end

    let(:invalid_attributes) do
      {
        team_id: "invalid uuid",
        user_id: "invalid uuid",
        ability: "invalid ability"
      }
    end

    before { allow(UsersOfTeamService).to receive(:call).and_return([valid_attributes[:user_id]]) }

    describe "POST /roles => roles#create" do
      context "with valid parameters" do
        before do
          post roles_url, params: { role: valid_attributes }, headers: valid_headers, as: :json
        end

        it "creates a new Role" do
          expect(Role.count).to be(1)
        end

        it "UserCheckService and UsersOfTeamService be called" do
          expect(UserCheckService).to have_received(:call).with(valid_attributes[:user_id])
          expect(UsersOfTeamService).to have_received(:call).with(valid_attributes[:team_id])
        end

        it "renders a JSON response with the new role" do
          expect(response).to have_http_status(:created)
          expect(response).to match_json_schema("role")
        end
      end

      context "with invalid parameters" do
        before do
          post roles_url, params: { role: invalid_attributes }, headers: valid_headers, as: :json
        end

        it "does not create a new Role" do
          expect(Role.count).to be(0)
        end

        it "renders a JSON response with errors for the new role" do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to match_json_schema("role_error")
        end
      end
    end

    describe "PATCH /update" do
      context "with valid parameters" do
        let!(:role) { create(:role, valid_attributes) }
        let(:new_attributes) do
          { ability: (["Developer", "Product Owner", "Tester"] - [valid_attributes[:ability]]).sample }
        end

        before do
          patch role_url(role), params: { role: new_attributes }, headers: valid_headers, as: :json
          role.reload
        end

        it "updates the requested role" do
          expect(role.ability_for_database).to be(new_attributes[:ability])
        end

        it "renders a JSON response with the role" do
          expect(response).to have_http_status(:ok)
          expect(response).to match_json_schema("role")
        end
      end

      context "with invalid parameters" do
        it "renders a JSON response with errors for the role" do
          role = Role.create! valid_attributes
          patch role_url(role), params: { role: invalid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to match_json_schema("role_error")
        end
      end
    end

    describe "DELETE /roles/:id => roles#destroy" do
      it "destroys the requested role" do
        role = Role.create! valid_attributes
        delete role_url(role), headers: valid_headers, as: :json
        expect(Role.count).to be(0)
      end
    end
  end
end
