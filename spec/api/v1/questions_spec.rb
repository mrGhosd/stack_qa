require 'rails_helper'

describe "Questions API" do
  describe "GET #index" do
    context "unauthorized" do
      it "returns 401 status if there is no access_token" do
        get "/api/v1/questions", format: :json
        expect(response.status).to eq(401)
      end

      it "returns 401 status if access_token is invalid" do
        get "/api/v1/questions", format: :json, access_token: '1234'
        expect(response.status).to eq(401)
      end
    end

    context "authorized" do
      let!(:access_token) { create :access_token }
      let!(:questions) { create_list(:question, 2) }
      let!(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }
      let!(:comment) { create(:comment, commentable_id: question.id, commentable_type: "Question") }

      before { get "api/v1/questions", format: :json, access_token: access_token.token }

      it "return 200 status code" do

        expect(response).to be_success
      end

      it "return a list of questions" do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title text created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context 'answers' do

        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id text created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/comments')
        end

        %w(id text created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("questions/0/comments/0/#{attr}")
          end
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
          post "api/v1/questions", format: :json,
               access_token: access_token.token,
               question: attributes_for(:question, category: category, user: user)
        }.to change(Question, :count).by(1)
      end

      it "return just create question" do
        post "api/v1/questions", format: :json,
             access_token: access_token.token,
             question: attributes_for(:question, category: category, user: user)
        expect(response.body).to be_json_eql(Question.last.to_json)
      end
    end

    context "with invalid attributes" do
      it "doesn't create an question" do
        expect { post "api/v1/questions", format: :json,
                access_token: access_token.token,
                question: attributes_for(:question,
                title: "", category: category, user: user) }.to change(Question, :count).by(0)
      end

      it "return array of json errors" do
        post "api/v1/questions", format: :json,
             access_token: access_token.token,
             question: attributes_for(:question,
             title: "", category: category, user: user)
        expect(JSON.parse(response.body)).to have_key("title")
      end
    end
  end
end