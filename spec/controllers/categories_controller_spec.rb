require 'rails_helper'

describe CategoriesController do
  login_user
  let!(:category) { create :category }

  describe "GET #index" do
    it "should return a list of categories" do
      get :index
      expect(assigns(:categories)).to eq([category])
    end

    it "render index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "show full info about category" do
      get :show, id: category.id
      expect(assigns(:category)).to eq(category)
    end

    it "render show template" do
      get :show, id: category.id
      expect(response).to render_template :show
    end
  end
end