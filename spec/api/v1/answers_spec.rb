require 'rails_helper'

describe "Answers API" do
  let!(:access_token) { create :access_token }
  let!(:user) { create :user }
  let!(:question) { create :question }
  let!(:answers) { create_list(:answer, 3, question: question) }
  let!(:answer) { answers.last }
  let!(:show_answer) { create :answer, question_id: question.id }
  let!(:comment) { create :comment, commentable_id: show_answer.id, commentable_type: "Answer" }

  describe "GET #index" do
    let!(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    it_behaves_like "API Authenticable"

    context "authorized" do
      before { get "/api/v1/questions/#{question.id}/answers", access_token: access_token.token }

      it "return a list of answers for particular question" do
        expect(response.body).to be_json_eql(answers.to_json)
      end

      %w(id text question_id).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end

  describe "GET #show" do

    before { get "/api/v1/questions/#{question.id}/answers/#{show_answer.id}", access_token: access_token.token }

    it "return an particular answer" do
      expect(response.body).to be_json_eql(show_answer.to_json)
    end

    it "include comments" do
      expect(response.body).to have_json_size(1).at_path('answer/comments')
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
     it "create a new answer" do
       expect {post "/api/v1/questions/#{question.id}/answers",
       access_token: access_token.token,
       answer: attributes_for(:answer, question: question, user: user) }.to change(Answer, :count).by(1)
     end

      it "return just created answer" do
        post "/api/v1/questions/#{question.id}/answers",
             access_token: access_token.token,
             answer: attributes_for(:answer, question: question, user: user)
        %w(id text user_id question_id).each do |attr|
          expect(response.body).to be_json_eql(Answer.first.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end
    end

    context "with invalid attributes" do
      it "doesn't create an answer" do
        expect {post "/api/v1/questions/#{question.id}/answers",
        access_token: access_token.token,
        answer: attributes_for(:answer, text: "", question: question, user: user) }.to change(Answer, :count).by(0)
      end

      it "return answer errors" do
        post "/api/v1/questions/#{question.id}/answers",
        access_token: access_token.token,
        answer: attributes_for(:answer, text: "", question: question, user: user)
        expect(JSON.parse(response.body)).to have_key("text")
      end
    end

  end
end