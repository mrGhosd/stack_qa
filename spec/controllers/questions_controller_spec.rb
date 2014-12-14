require 'rails_helper'

describe QuestionsController do
  let!(:question) { create :question, :unclosed }
  describe "GET #index" do
    it "return list of all questions" do
      get :index
      expect(Question.all).to match_array(question)
    end

    it "render the index  template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "locate a current questions" do
      get :show, id: question.id
      expect(assigns(:question)).to eq(question)
    end

    it "render the show template" do
      get :show, id: question.id
      expect(repsponse).to render_template :show
    end
  end

  describe "GET #edit" do
    
  end

  describe "POST #create" do

  end

  describe "PUT #update" do

  end

  describe "DELETE #destroy" do

  end
end