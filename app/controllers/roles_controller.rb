# frozen_string_literal: true

class RolesController < ApplicationController
  before_action :set_role, only: %i[show update destroy]

  def index
    @roles = Role.all
  end

  def index_by_team
    @roles = Role.where(team_id: params[:team_id])
    render(:index)
  end

  def index_by_user
    @roles = Role.where(user_id: params[:user_id])
    render(:index)
  end

  def index_by_ability
    if Role.abilities.key?(params[:ability]) || Role.abilities.value?(params[:ability])
      @roles = Role.where(ability: params[:ability])
      render(:index)
    else
      render(status: :bad_request, json: { error: "'#{params[:ability]}' is not a valid ability" })
    end
  end

  def index_by_ability_and_team
    if Role.abilities.key?(params[:ability]) || Role.abilities.value?(params[:ability])
      @roles = Role.where(ability: params[:ability], team_id: params[:team_id])
      render(:index)
    else
      render(status: :bad_request, json: { error: "'#{params[:ability]}' is not a valid ability" })
    end
  end

  def index_by_team_and_user
    @role = Role.where(team_id: params[:team_id], user_id: params[:user_id])
    render(:index)
  end

  def show; end

  def create
    @role = Role.new(role_params)

    if @role.save
      render(:show, status: :created, location: @role)
    else
      render(json: @role.errors, status: :unprocessable_entity)
    end
  end

  def update
    if @role.update(role_params)
      render(:show, status: :ok, location: @role)
    else
      render(json: @role.errors, status: :unprocessable_entity)
    end
  end

  def destroy
    @role.destroy!
  end

  private
    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.require(:role).permit(:team_id, :user_id, :ability)
    end
end
