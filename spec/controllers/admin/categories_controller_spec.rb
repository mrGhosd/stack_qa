require 'rails_helper'
require 'admin/categories_controller'
describe Admin::CategoriesController do
  login_admin
  let!(:category){ create :category }

  describe "GET #new" do
    it "create new empty category" do
      get :new
      expect(assigns(:category)).to eq(Category.new)
    end

    it "render 'new' template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    
  end
end