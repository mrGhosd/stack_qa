class Api::V1::UsersController < Api::ApiController
  prepend_before_filter :allow_params_authentication!, :only => :create
  skip_before_filter :restrict_access_by_token, :only => :create
  
  def create
    user = User.new(user_params)
    if user.save
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :unprocessible_entity
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end