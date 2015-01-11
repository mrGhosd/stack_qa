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
    context "with valid attributes" do
      it "create a new category" do
        expect{post :create,
        category: attributes_for(:category)}.to change(Category, :count).by(1)
      end

      it "return 200 status" do
        post :create, category: attributes_for(:category)
        expect(response.status).to eq(200)
      end
    end

    context "with invalid attributes" do
      it "doesn't create a new category" do
        expect{post :create,
        category: attributes_for(:category, title: "")}.to change(Category, :count).by(0)
      end

      it "return category errors" do
        post :create,
        category: attributes_for(:category, title: "")
        expect(JSON.parse(response.body)).to have_key('title')
      end
    end
  end
end