require 'rails_helper'

describe "Comments API" do
  let!(:access_token) { create :access_token }
  let!(:category) { create :category }
  let!(:user) { create :user }
  let!(:question) { create :question, user_id: user.id, category_id: category.id }
  let!(:answer) { create :answer, question_id: question.id, user_id: user.id }
  let!(:question_comment) { create :comment, user_id: user.id, commentable_id: question.id, commentable_type: question.class.to_s }
  let!(:answer_comment) { create :comment, user_id: user.id, commentable_id: answer.id, commentable_type: answer.class.to_s }

  # let!(:entity) { question }
  # let!(:url) { "api/v1/questions/#{quesiton.id}/comments" }

  describe "GET #index" do

    context "question" do
      before { get "api/v1/questions/#{question.id}/comments", access_token: access_token.token }

      %w(id user_id commentable_id commentable_type text user question answer ).each do |attr|
        it "comment object contains #{attr}" do
          expect(response.body).to be_json_eql(question_comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
        end
      end
    end

    context "answer" do
      before { get "api/v1/questions/#{question.id}/answers/#{answer.id}/comments", access_token: access_token.token }

      %w(id user_id commentable_id commentable_type text user question answer ).each do |attr|
        it "comment object contains #{attr}" do
          expect(response.body).to be_json_eql(answer_comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
        end
      end
    end
  end

  describe "POST #create" do
    context "question" do
      context "with valid attributes" do
        it "create a new comment" do
          expect { post "api/v1/questions/#{question.id}/comments",
          access_token: access_token.token, comment: attributes_for(:comment, user_id: user.id,
          commentable_id: question.id, commentable_type: question.class.to_s) }.to change(Comment, :count).by(1)
        end

        before { post "api/v1/questions/#{question.id}/comments",
                  access_token: access_token.token, comment: attributes_for(:comment, user_id: user.id,
                  commentable_id: question.id, commentable_type: question.class.to_s) }
        %w(user_id commentable_id commentable_type text user question answer).each do |attr|
          it "comment object contains #{attr}" do
            expect(response.body).to be_json_eql(Comment.last.send(attr.to_sym).to_json).at_path("#{attr}")
          end
        end
      end

      context "with invalida attributes" do
        it "doesn't create a new comment" do
          expect { post "api/v1/questions/#{question.id}/comments",
          access_token: access_token.token, comment: attributes_for(:comment, user_id: user.id,
          commentable_id: question.id, commentable_type: question.class.to_s, text: "") }.to change(Comment, :count).by(0)
        end

        it "return a comment's error list" do
          post "api/v1/questions/#{question.id}/comments",
          access_token: access_token.token, comment: attributes_for(:comment, user_id: user.id,
          commentable_id: question.id, commentable_type: question.class.to_s, text: "")
          expect(JSON.parse(response.body)).to have_key("text")
        end
      end
    end
  end

  describe "PUT #update" do
    context "question" do
      context "with valid attributes" do
        it "update a comment" do
          put "api/v1/questions/#{question.id}/comments/#{question_comment.id}",
          access_token: access_token.token, comment: attributes_for(:comment, user_id: user.id,
          commentable_id: question.id, commentable_type: question.class.to_s, text: "222")
          question_comment.reload
          expect(question_comment.text).to eq("222")
        end

        before { put "api/v1/questions/#{question.id}/comments/#{question_comment.id}",
        access_token: access_token.token, comment: attributes_for(:comment, user_id: user.id,
        commentable_id: question.id, commentable_type: question.class.to_s) }

        %w(user_id commentable_id commentable_type text user question answer).each do |attr|
          it "comment object contains #{attr}" do
            expect(response.body).to be_json_eql(Comment.last.send(attr.to_sym).to_json).at_path("#{attr}")
          end
        end
      end

      context "with invalid attributes" do
        it "doesn't update a new comment" do
          put "api/v1/questions/#{question.id}/comments/#{question_comment.id}",
          access_token: access_token.token, comment: attributes_for(:comment, user_id: user.id,
          commentable_id: question.id, commentable_type: question.class.to_s, text: "")
          question_comment.reload
          expect(question_comment.text).to eq(question_comment.text)
        end

        it "return a comment's error list" do
          put "api/v1/questions/#{question.id}/comments/#{question_comment.id}",
          access_token: access_token.token, comment: attributes_for(:comment, user_id: user.id,
          commentable_id: question.id, commentable_type: question.class.to_s, text: "")
          expect(JSON.parse(response.body)).to have_key("text")
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "question" do
      it "delete comment" do
        expect { delete "api/v1/questions/#{question.id}/comments/#{question_comment.id}",
        access_token: access_token.token }.to change(Comment, :count).by(-1)
      end

      it "return success status" do
        delete "api/v1/questions/#{question.id}/comments/#{question_comment.id}",
               access_token: access_token.token
        expect(response.status).to eq(200)
      end
    end
  end

end