class Api::V1::RegistrationsController < ApiController
  prepend_before_filter :allow_params_authentication!, :only => :create
  skip_before_filter :restrict_access_by_token, :only => :create
  respond_to :json

  def create
    binding.pry
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end