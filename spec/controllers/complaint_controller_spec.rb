require 'rails_helper'

describe ComplaintsController do
  login_user
  let!(:category) { create :category }
  let!(:question) { create :question, user_id: subject.current_user.id, category_id: category.id }
  let!(:complaint) { create :complaint, user_id: subject.current_user.id, complaintable_id: question.id, complaintable_type: question.class.to_s }

  describe "POST #create" do
    it "create a new complaint" do
      expect { post :create, question_id: question.id, complaint: attributes_for(:complaint,
      user_id: subject.current_user.id, complaintable_id: question.id,
      complaintable_type: question.class.to_s) }.to change(Complaint, :count).by(1)
    end

    it "return 200 HTTP status" do
      post :create, question_id: question.id, complaint: attributes_for(:complaint,
      user_id: subject.current_user.id, complaintable_id: question.id,
      complaintable_type: question.class.to_s)
      expect(response.status).to eq(200)
    end
  end
end