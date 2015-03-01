require 'rails_helper'

describe UsersController do
  login_admin

  describe "GET #edit" do
    it "define particular user" do
      get :edit, id: subject.current_user.id
      expect(assigns(:user)).to eq(subject.current_user)
    end

    it "render edit template" do
      get :edit, id: subject.current_user.id
      expect(response).to render_template :edit
    end
  end

  describe "GET #show" do
    let!(:question){ create :question, user_id: subject.current_user.id }
    let!(:answer){ create :answer, user_id: subject.current_user.id, question_id: question.id }
    let!(:comment) { create :comment, user_id: subject.current_user.id, commentable_type: question.class.to_s, commentable_id: question.id }

    it "find a user and load his data" do
      get :show, id: subject.current_user.id
      expect(assigns(:user)).to eq(subject.current_user)
      expect(assigns(:questions)).to match_array(question)
      expect(assigns(:answers)).to match_array(answer)
      expect(assigns(:comments)).to match_array(comment)
      expect(assigns(:statistic)).to eq(subject.current_user.statistic)
    end

    it "render show template" do
      get :show, id: subject.current_user.id
      expect(response).to render_template :show
    end
  end

  describe "PUT #update" do
    it "define an user" do
      put :update, id: subject.current_user.id, user: attributes_for(:user, name: "AAA")
      expect(assigns(:user)).to eq(subject.current_user)
    end

    it "update user's attributes" do
      put :update, id: subject.current_user.id, user: attributes_for(:user, name: "AAA")
      subject.current_user.reload
      expect(subject.current_user.name).to eq "AAA"
    end

    it "redirect to user page" do
      put :update, id: subject.current_user.id, user: attributes_for(:user, name: "AAA")
      expect(response).to redirect_to user_path(subject.current_user)
    end
  end
end