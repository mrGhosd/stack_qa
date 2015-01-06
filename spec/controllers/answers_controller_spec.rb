require 'rails_helper'

describe AnswersController do
  login_user
  let!(:question) { create :question, user_id: subject.current_user.id }
  let!(:answer) { create :answer, user_id: subject.current_user.id, question_id: question.id }

  describe "GET #new" do
    it "create empty entity of answer" do
      get :new, question_id: question.id
      expect(assigns(:question)).to eq(question)
      expect(assigns(:answer)).to eq(question.answers.build(user_id: subject.current_user.id))
    end

    it "render 'new' template" do
      get :new, question_id: question.id
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    it "assigns current answer" do
      get :edit, question_id: question.id, id: answer.id
      expect(assigns(:question)).to eq(question)
      expect(assigns(:answer)).to eq(answer)
    end

    it "render 'edit' partial" do
      get :edit, question_id: question.id, id: answer.id
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "create new answer" do
        expect{post :create,
        question_id: question.id,
        answer: attributes_for(:answer, user_id: subject.current_user.id)}.to change(Answer, :count).by(1)
      end

      it "return just created answer" do
        post :create, question_id: question.id, answer: attributes_for(:answer, question_id: question.id, user_id: subject.current_user.id)
        expect(response.body).to eq(Answer.first.to_json)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "update attributes of current answer" do
        put :update, question_id: question.id, id: answer.id, answer: attributes_for(:answer, text: "1")
        answer.reload
        expect(answer.text).to eq("1")
      end

      it "return updated answer" do
        put :update, question_id: question.id, id: answer.id, answer: attributes_for(:answer, text: "1")
        expect(response.body).to eq(answer.to_json)
      end
    end
  end

  describe "DELETE #destroy" do
    it "delete answer" do
      expect{delete :destroy,
      question_id: question.id,
      id: answer.id}.to change(Answer, :count).by(-1)
    end

    it "return 200 status" do
      delete :destroy,
      question_id: question.id,
      id: answer.id
      expect(response.status).to eq(200)
    end
  end
end