class UsersController < ApplicationController

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
    @questions = @user.questions
    @answers = @user.answers
  end

  def paginate_users_questions

  end

  private

  def user_params
    params.require(:user).permit(:surname, :name)
  end
end