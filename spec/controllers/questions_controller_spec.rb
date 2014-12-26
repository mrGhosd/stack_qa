require 'rails_helper'

describe QuestionsController do
  login_user
  let!(:question) { create :question, :unclosed, user_id: subject.current_user.id }

  describe "GET #index" do
    it "return list of all questions" do
      get :index
      expect(assigns(:questions)).to eq(Question.all)
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
      expect(response).to render_template :show
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
    context "with valid attributes" do
      it "create a new question" do
        expect{post :create, question: attributes_for(:question, title: "1", user_id: subject.current_user.id)}.to change(Question, :count).by(1)
      end

      it "redirect to questions list" do
        post :create, question: attributes_for(:question, title: "2", user_id: subject.current_user.id)
        expect(response).to redirect_to questions_path
      end
    end

    context "with invalid attributes" do

    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      it "update question parameters" do
        put :update, id: question, question: attributes_for(:question, title: "adawkdawokd;awd", user_id: subject.current_user.id)
        question.reload
        expect(question.title).to eq("adawkdawokd;awd")
      end

      it "redirect to show question page" do
        put :update, id: question, question: attributes_for(:question, user_id: subject.current_user.id)
        expect(response).to redirect_to question_path(id: question.id)
      end
    end
    context "with invalid attributes" do

    end
  end

  describe "DELETE #destroy" do
    it "destroy the choosen question" do
      expect{delete :destroy, id: question.id}.to change(Question, :count).by(-1)
    end

    it "return 200 status" do
      delete :destroy, id: question.id
      expect(response.status).to eq(200)
    end
  end
end