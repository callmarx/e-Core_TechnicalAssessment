Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :roles, only: [:index, :show, :create, :update, :destroy]

  get "roles/team/:team_id", to: "roles#index_by_team", as: "roles_by_team"
  get "roles/user/:user_id", to: "roles#index_by_user", as: "roles_by_user"
  get "roles/ability/:ability", to: "roles#index_by_ability", as: "roles_by_ability"
  get "roles/membership/:team_id/:user_id", to: "roles#show_by_team_and_user", as: "role_by_team_and_user"
end
