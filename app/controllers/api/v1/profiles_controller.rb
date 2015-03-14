class Api::V1::ProfilesController < Api::ApiController
  before_action :doorkeeper_authorize!, only: :me

  def index
    users = User.where.not(id: current_resource_owner.id)
    render json: users.to_json
  end

  def me
    render json: current_resource_owner.to_json(except: [:password, :password_encrypted])
  end
end


