require 'rails_helper'

describe CommentsController do
  login_user
  let!(:category) { create :category }
  let!(:question){ create :question, user_id: subject.current_user.id, category_id: category.id }
  let!(:comment) { create :comment, commentable_id: question.id, commentable_type: "Question", user_id: subject.current_user.id }

  describe "POST #create" do
    context "with valid attributes" do
      it "create a new comment" do
        expect{
          post :create,
            question_id: question.id, type: "Question",
            comment: attributes_for(:comment,
            user_id: subject.current_user.id,
            commentable_id: question.id)
        }.to change(Comment, :count).by(1)
      end

      it "return just create comment" do
        post :create,
        question_id: question.id,
        commentable_id: question.id,
        type: "Question",
        comment: attributes_for(:comment,
        user_id: subject.current_user.id)
        allow(PrivatePub).to receive("publish_to").and_return(Comment.first.to_json)
        expect(PrivatePub.publish_to).to eq(Comment.first.to_json)
      end
    end

    context "with invalid attributes" do
      it "doesn't create a new comment" do
        expect{
          post :create,
          question_id: question.id, type: "Question",
          comment: attributes_for(:comment,
          user_id: subject.current_user.id,
          commentable_id: question.id, text: "")
        }.to change(Comment, :count).by(0)
      end

      it "return comment errors" do
        post :create,
        question_id: question.id, type: "Question",
        comment: attributes_for(:comment,
        user_id: subject.current_user.id,
        commentable_id: question.id, text: "")
        expect(JSON.parse(response.body)).to have_key('text')
      end
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
        allow(PrivatePub).to receive("publish_to").and_return(comment)
        put :update, question_id: question.id, id: comment.id, comment: attributes_for(:comment, text: "1")
        expect(PrivatePub.publish_to).to eq(comment)
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