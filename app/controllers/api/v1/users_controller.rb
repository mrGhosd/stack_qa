class Api::V1::UsersController < Api::ApiController
  prepend_before_filter :allow_params_authentication!, :only => :create
  skip_before_filter :restrict_access_by_token, :only => :create

  def create
    user = User.new(user_params)
    if user.save
      render json: { success: true }, status: :ok
    else
      render json: user.errors.to_json, status: :unprocessible_entity
    end
  end

  def show
    user = User.find(params[:id])
    render json: user.as_json(except: [:password, :password_encrypted], methods: [:correct_naming, :rate, :questions_count, :answers_count, :comments_count, :statistic])
  end

  def questions
    user = User.find(params[:id])
    render json: user.questions.as_json, status: :ok
  end

  def answers
    user = User.find(params[:id])
    render json: user.answers.as_json, status: :ok
  end

  def comments
    user = User.find(params[:id])
    render json: user.comments.as_json(methods: [:question, :answer]), status: :ok
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end