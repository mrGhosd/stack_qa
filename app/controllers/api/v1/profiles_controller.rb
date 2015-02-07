class Api::V1::ProfilesController < Api::ApiController

  def index
    @questions = Question.where.not(id: current_resource_owner.id)
  end

  def me
    render json: current_resource_owner.to_json(except: [:password, :password_encrypted])
  end

end


