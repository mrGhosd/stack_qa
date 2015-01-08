require 'rails_helper'

describe CommentsController do

  describe "GET #new" do
    login_user
    let!(:question){ create :question, user_id: subject.current_user.id }

    it "create a new entity of a comment" do
      get :new, question_id: question.id
      expect(assigns(:question)).to eq(question)
      expect(assigns(:comment).attributes).to eq(Comment.new(user_id: subject.current_user.id, question_id: question.id).attributes)
    end

    it "render 'new' partial" do
      get :new, question_id: question.id
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    it "create a new comment" do

    end
  end
end