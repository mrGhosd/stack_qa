class Api::V1::ProfilesController < Api::ApiController
  respond_to    :json

  def me
    render json: current_resource_owner.to_json(except: [:password, :password_encrypted])
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end


