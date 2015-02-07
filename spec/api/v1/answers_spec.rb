require 'rails_helper'

describe "Answers API" do
  describe "GET #index" do
    let!(:access_token) { create :access_token }
    let!(:question) { create :question }

    context "unauthorized" do
      it "returns 401 status if there is no access_token" do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq(401)
      end

      it "returns 401 status if access_token is invalid" do
        get "/api/v1/questions", format: :json, access_token: '1234'
        expect(response.status).to eq(401)
      end
    end

    context "authorized" do
      let!(:answers) { create_list(:answer, 3, question: question) }
      let!(:answer) { answers.last }

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
end