require 'rails_helper'

describe "Answers API" do
  let!(:access_token) { create :access_token }
  let!(:category) { create :category }
  let!(:user) { create :user }
  let!(:question) { create :question, user_id: user.id, category_id: category.id }
  let!(:answers) { create_list(:answer, 3, question_id: question.id, user_id: user.id) }
  let!(:answer) { answers.last }

  describe "GET #index" do
    let!(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    it_behaves_like "API Authenticable"

    context "authorized" do
      before { get "/api/v1/questions/#{question.id}/answers", access_token: access_token.token }

      %w(id text question_id user_id user_name comments_count).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end

      it "return 200 status" do
        expect(response.status).to eq(200)
      end
    end
  end

  describe "GET #show" do
    let!(:show_answer) { create :answer, question_id: question.id }
    let!(:comment) { create :comment, commentable_id: show_answer.id, commentable_type: "Answer" }

    before { get "/api/v1/questions/#{question.id}/answers/#{show_answer.id}", access_token: access_token.token }

    it "return an particular answer" do
      expect(response.body).to be_json_eql(show_answer.id.to_json).at_path("id")
    end

  end

  describe "POST #create" do
    context "with valid attributes" do
     it "create a new answer" do
       expect {post "/api/v1/questions/#{question.id}/answers",
       access_token: access_token.token,
       answer: attributes_for(:answer, question_id: question.id, user_id: user.id) }.to change(Answer, :count).by(1)
     end

      it "return just created answer" do
        post "/api/v1/questions/#{question.id}/answers",
             access_token: access_token.token,
             answer: attributes_for(:answer, question_id: question.id, user_id: user.id)
        %w(id text user_id question_id).each do |attr|
          expect(response.body).to be_json_eql(Answer.first.send(attr.to_sym).to_json).at_path("#{attr}")
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

  describe "PUT #update" do
    context "with valid attributes" do
      it "update an answer" do
        put "/api/v1/questions/#{question.id}/answers/#{answer.id}",
            access_token: access_token.token,
            answer: attributes_for(:answer, question_id: question.id, user_id: user.id, text: "222")
        answer.reload
        expect(answer.text).to eq("222")
      end

      it "return just updated answer" do
        put "/api/v1/questions/#{question.id}/answers/#{answer.id}",
            access_token: access_token.token,
            answer: attributes_for(:answer, question_id: question.id, user_id: user.id, text: "222")
        answer.reload
        expect(response.body).to eq(answer.as_json(methods: [:comments_count, :user_name]).to_json)
      end
    end

    context "with invalid attributes" do
      it "doesn't update answer" do
        put "/api/v1/questions/#{question.id}/answers/#{answer.id}",
            access_token: access_token.token,
            answer: attributes_for(:answer, question_id: question.id, user_id: user.id, text: "")
        answer.reload
        expect(answer.text).to eq(answer.text)
      end

      it "return answer errors" do
        put "/api/v1/questions/#{question.id}/answers/#{answer.id}",
            access_token: access_token.token,
            answer: attributes_for(:answer, question_id: question.id, user_id: user.id, text: "")
        answer.reload
        expect(JSON.parse(response.body)).to have_key("text")
      end
    end
  end

  describe "DELETE #destroy" do
    it "delete answer" do
      expect { delete "/api/v1/questions/#{question.id}/answers/#{answer.id}",
          access_token: access_token.token }.to change(Answer, :count).by(-1)
    end

    context "question was answered and answer is helpfull" do
      before do
        answer.update(is_helpfull: true)
        question.update(is_closed: true)
        delete "/api/v1/questions/#{question.id}/answers/#{answer.id}",
               access_token: access_token.token
      end

      it "mark question as unclosed" do
        question.reload
        expect(question.is_closed).to eq(false)
      end
    end

    it "return success status" do
      delete "/api/v1/questions/#{question.id}/answers/#{answer.id}", access_token: access_token.token
      expect(response.status).to eq(200)
    end
  end
end