require 'rails_helper'

describe CommentsController do
  login_user
  let!(:question){ create :question, user_id: subject.current_user.id }
  let!(:comment) { create :comment, question_id: question.id, user_id: subject.current_user.id }

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
        expect(JSON.parse(response.body)).to have_key('text')
      end
    end
  end

  describe "GET #edit" do
    it "assigns comment and question" do
      get :edit, question_id: question.id, id: comment.id
      expect(assigns(:question)).to eq(question)
      expect(assigns(:comment)).to eq(comment)
    end

    it "rendere edit partial" do
      get :edit, question_id: question.id, id: comment.id
      expect(response).to render_template :edit
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      it "change comments attributes" do
        put :update, question_id: question.id, id: comment.id, comment: attributes_for(:comment, text: "1")
        comment.reload
        expect(comment.text).to eq("1")
      end

      it "return updated comment" do
        put :update, question_id: question.id, id: comment.id, comment: attributes_for(:comment, text: "1")
        json = JSON.parse(response.body)
        json['created_at'] = json['created_at'].to_datetime
        json['updated_at'] = json['updated_at'].to_datetime
        comment.created_at = answer.created_at.to_datetime.utc
        comment.updated_at = answer.updated_at.to_datetime.utc
        comment.save
        expect(json).to eq(comment.attributes)
      end
    end

    context "with invalid attributes" do
      it "stay comment attributes same" do
        put :update, question_id: question.id, id: comment.id, comment: attributes_for(:comment, text: "")
        comment.reload
        expect(comment.text).to eq(comment.text)
      end

      it "return array of comment errors" do
        put :update, question_id: question.id, id: comment.id, comment: attributes_for(:comment, text: "")
        expect(JSON.parse(response.body)).to have_key('text')
      end
    end
  end

  describe "DELETE #destory" do
    it "remove existing comment" do
      expect{delete :destroy,
      question_id: question.id,
      id: comment.id}.to change(Comment, :count).by(-1)

    end

    it "return 200 status" do
      delete :destroy, question_id: question.id, id: comment.id
      expect(response.status).to eq(200)
    end
  end
end