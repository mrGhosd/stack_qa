require 'rails_helper'
require 'admin/categories_controller'
describe Admin::CategoriesController do
  login_admin
  let!(:category){ create :category }

  describe "GET #index" do
    it "return a list of categoris" do
      get :index
      expect(assigns(:categories)).to eq([category])
    end

    it "render index template" do
      get :index
      expect(response).to render_template :index
    end
  end


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
        category: attributes_for(:category, title: "new")}.to change(Category, :count).by(1)
      end

      it "return 200 status" do
        post :create, category: attributes_for(:category, title: "new"), format: :json
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
        category: attributes_for(:category, title: ""), format: :json
        expect(JSON.parse(response.body)).to have_key('title')
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "update particular category" do
        put :update, id: category.id, category: attributes_for(:category, title: "LOL")
        category.reload
        expect(category.title).to eq("LOL")
      end

      it "return this category" do
        put :update, id: category.id, category: attributes_for(:category, title: "LOL")
        category.reload
        expect(response.body).to eq(category.attributes)
      end
    end

    context "with invalid attributes" do

    end
  end
end