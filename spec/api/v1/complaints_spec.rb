require 'rails_helper'

describe "Complaints API" do
  let!(:access_token) { create :access_token }
  let!(:category) { create :category }
  let!(:user) { create :user }
  let!(:question) { create :question, user_id: user.id, category_id: category.id }

  describe "POST #create" do
    it "create a new complaint" do
      expect { post "/api/v1/questions/#{question.id}/complaints", format: :json,
      access_token: access_token.token, question_id: question.id, complaint: attributes_for(:complaint, user_id: user.id,
      complaintable_id: question.id, complaintable_type: question.class.to_s) }.to change(Complaint, :count).by(1)
    end

    it "return just created complaint" do
      post "/api/v1/questions/#{question.id}/complaints", format: :json,
      access_token: access_token.token, complaint: attributes_for(:complaint, user_id: user.id,
      complaintable_id: question.id, question_id: question.id, complaintable_type: question.class.to_s)
      expect(response.body).to eq(Complaint.last.to_json)
    end
  end
end