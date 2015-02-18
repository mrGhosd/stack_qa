class UsersController < ApplicationController

  def edit
    @user = User.find(params[:id])
    render :edit, layout: false
  end

  def show
    @user = User.find(params[:id])
    @questions = @user.questions
    @answers = @user.answers
    @comments = @user.comments
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render json: @user.errors.to_json
    end
  end

  private

  def user_params
    params.require(:user).permit(:surname, :name, :email, :date_of_birth, :place_of_birth, :avatar)
  end
end