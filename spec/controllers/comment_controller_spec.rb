require 'rails_helper'

describe CommentsController do

  describe "GET #new" do
    let!(:user) { create :user }
    let!(:question){ create :question, user_id: user.id }

    it "create a new entity of a comment" do
      get :new, question_id: question.id
      expect(assigns(:question)).to eq(question)
      expect(assigns(:comment)).to eq(Comment.new(user_id: user.id, question_id: question.id))
    end

    it "render 'new' partial" do
      get :new, question_id: question.id
      expect(response).to render_template :new
    end
  end
end