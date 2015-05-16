require 'rails_helper'

describe ComplaintsController do
  let!(:user) { create :user }
  let!(:category) { create :category }
  let!(:question) { create :question, user_id: user.id, category_id: category.id }
  let!(:complaint) { create :complaint, user_id: user.id, complaintable_id: question.id, complaintable_type: question.class.to_s }

  describe "POST #create" do
    it "create a new complaint" do
      expect { post :create, id: question.id, complaint: attributes_for(:complaint,
      user_id: user.id, complaintable_id: question.id,
      complaintable_type: question.class.to_s) }.to change(Complaint, :count).by(1)
    end

    it "return just created complaint" do
      post :create, id: question.id, complaint: attributes_for(:complaint,
      user_id: user.id, complaintable_id: question.id,
      complaintable_type: question.class.to_s)
      expect(response.body).to eq(Complaint.last.to_json)
    end
  end
end