require 'rails_helper'

describe "Questions API" do
  describe "GET #index" do
    let!(:api_path) { "/api/v1/questions" }
    it_behaves_like "API Authenticable"

    context "authorized" do
      let!(:category) { create :category }
      let!(:access_token) { create :access_token }
      let!(:questions) { create_list(:question, 2, category_id: category.id) }
      let!(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }
      let!(:comment) { create(:comment, commentable_id: question.id, commentable_type: "Question") }

      before { get "/api/v1/questions", format: :json, access_token: access_token.token }

      it "return 200 status code" do

        expect(response).to be_success
      end

      it "return a list of questions" do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title comments_count).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end
    end
  end

  describe "POST #create" do
    let!(:user) { create :user }
    let!(:access_token) { create :access_token }
    let!(:category) { create :category }

    context "with valid attributes" do
      it "creates a new question" do
        expect{
          post "/api/v1/questions", format: :json,
               access_token: access_token.token,
               question: attributes_for(:question, category_id: category.id, user: user)
        }.to change(Question, :count).by(1)
      end

      it "return just create question" do
        post "/api/v1/questions", format: :json,
             access_token: access_token.token,
             question: attributes_for(:question, category_id: category.id, user: user)
        expect(response.body).to be_json_eql(Question.last.to_json)
      end
    end

    context "with invalid attributes" do
      it "doesn't create an question" do
        expect { post "/api/v1/questions", format: :json,
                access_token: access_token.token,
                question: attributes_for(:question,
                title: "", category_id: category.id, user: user) }.to change(Question, :count).by(0)
      end

      it "return array of json errors" do
        post "/api/v1/questions", format: :json,
             access_token: access_token.token,
             question: attributes_for(:question,
             title: "", category_id: category.id, user: user)
        expect(JSON.parse(response.body)).to have_key("title")
      end
    end
  end

  describe "GET #show" do
    let!(:category) { create :category }
    let!(:user) { create :user }
    let!(:question) { create :question, category_id: category.id, user_id: user.id }
    # login_user

    before { get "/api/v1/questions/#{question.id}" }

    %w(id title text comments_count tag_list answers_count category user).each do |attr|
      it "question object contains #{attr}" do
        expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
      end
    end

    it "return 200 status" do
      expect(response.status).to eq(200)
    end
  end

  describe "PUT #update" do
    let!(:user) { create :user }
    let!(:access_token) { create :access_token }
    let!(:category) { create :category }
    let!(:question) { create :question, user_id: user.id, category_id: category.id }

    context "with valid attributes" do
      it "update question" do
        put "/api/v1/questions/#{question.id}", format: :json,
            id: question.id,
            access_token: access_token.token,
            question: attributes_for(:question, user_id: user.id, category_id: category.id, title: "2")
        question.reload
        expect(question.title).to eq("2")
      end

      it "return just updated question" do
        put "/api/v1/questions/#{question.id}", format: :json,
            id: question.id,
            access_token: access_token.token,
            question: attributes_for(:question, user_id: user.id, category_id: category.id, title: "2")
        question.reload
        expect(response.body).to eq(question.to_json)
      end
    end

    context "with invalid attributes" do
      it "doesn't update question" do
        put "/api/v1/questions/#{question.id}", format: :json,
            id: question.id,
            access_token: access_token.token,
            question: attributes_for(:question, user_id: user.id, category_id: category.id, title: "")
        question.reload
        expect(question.title).to eq(question.title)
      end

      it "return json error" do
        put "/api/v1/questions/#{question.id}", format: :json,
            id: question.id,
            access_token: access_token.token,
            question: attributes_for(:question, user_id: user.id, category_id: category.id, title: "")
        question.reload
        expect(JSON.parse(response.body)).to have_key("title")
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:user) { create :user }
    let!(:access_token) { create :access_token }
    let!(:category) { create :category }
    let!(:question) { create :question, user_id: user.id, category_id: category.id }

    it "delete question" do
      expect{ delete "/api/v1/questions/#{question.id}", format: :json,
      id: question.id, access_token: access_token.token }.to change(Question, :count).by(-1)
    end

    it "return success status" do
      delete "/api/v1/questions/#{question.id}", format: :json,
             id: question.id, access_token: access_token.token
      expect(response.status).to eq(200)
    end

  end
end