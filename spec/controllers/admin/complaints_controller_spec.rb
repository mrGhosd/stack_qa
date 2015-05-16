require 'rails_helper'
require 'admin/complaints_controller'

describe Admin::ComplaintsController do
  login_admin
  let!(:user) { create :user }
  let!(:category) { create :category }
  let!(:question) { create :question, user_id: user.id, category_id: category.id }
  let!(:complaint) { create :complaint, complaintable_type: question.class.to_s, complaintable_id: question.id, user_id: user.id }

  describe "GET #index" do
    it "show a list of complaints" do
      get :index
      expect(assigns(:complaints)).to match_array([complaint])
    end

    it "render index template" do
      get :index
      expect(response).to render_template :index
    end
  end
end