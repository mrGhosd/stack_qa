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
    it "locate a question" do
      get :edit, id: question.id
      expect(assigns(:question)).to eq(question)
    end

    it "render edit template" do
      get :edit, id: question.id
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    it "create a new question" do
      expect{post :create, question: attributes_for(:question)}.to change(Question, :count).by(1)
    end

    it "redirect to questions list" do
      post :create, question: attributes_for(:question)
      expect(response).to redirect_to questions_path
    end
  end

  describe "PUT #update" do
    it "update question parameters" do
      put :update, question: attributes_for(:question, title: "adawkdawokd;awd")
      question.reload
      expect(question.title).to eq("adawkdawokd;awd")
    end

    it "redirect to show question page" do
      put :update, question: attributes_for(:question)
      expect(response).to redirect_to question_path(id: question.id)
    end
  end

  describe "DELETE #destroy" do
    it "destroy the choosen question" do

    end

    
  end
end