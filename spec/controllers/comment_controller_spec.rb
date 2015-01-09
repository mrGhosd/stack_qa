require 'rails_helper'

describe CommentsController do
  login_user
  let!(:question){ create :question, user_id: subject.current_user.id }

  describe "GET #new" do
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
    context "with valid attributes" do
      it "create a new comment" do
        expect{post :create,
        question_id: question.id,
        comment: attributes_for(:comment,
        user_id: subject.current_user.id,
        question_id: question.id)}.to change(Comment, :count).by(1)
      end

      it "return just create comment" do
        post :create,
        question_id: question.id,
        comment: attributes_for(:comment,
        user_id: subject.current_user.id,
        question_id: question.id)
        expect(response.body).to eq(Comment.first.to_json)
      end
    end

    context "with invalid attributes" do
      it "doesn't create a new comment" do
        expect{post :create,
        question_id: question.id,
        comment: attributes_for(:comment,
        user_id: subject.current_user.id,
        question_id: question.id, text: "")}.to change(Comment, :count).by(0)
      end

      it "return comment errors" do
        post :create,
        question_id: question.id,
        comment: attributes_for(:comment,
        user_id: subject.current_user.id,
        question_id: question.id, text: "")

      end
    end
  end
end