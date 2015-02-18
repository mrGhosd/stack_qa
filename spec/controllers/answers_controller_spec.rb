require 'rails_helper'

describe AnswersController do
  login_user
  let!(:question) { create :question, user_id: subject.current_user.id }
  let!(:answer) { create :answer, user_id: subject.current_user.id, question_id: question.id }

  describe "GET #new" do
    it "create empty entity of answer" do
      get :new, question_id: question.id
      expect(assigns(:question)).to eq(question)
      expect(assigns(:answer).attributes).to eq(question.answers.build(user_id: subject.current_user.id).attributes)
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

      it "return private_pub message, that contains the answer" do
        allow(PrivatePub).to receive("publish_to").and_return(answer)
        put :update, question_id: question.id, id: answer.id, answer: attributes_for(:answer, text: "1")
        binding.pry
        json = JSON.parse(response.body)
        json['created_at'] = json['created_at'].to_datetime
        json['updated_at'] = json['updated_at'].to_datetime
        answer.created_at = answer.created_at.to_datetime.utc
        answer.updated_at = answer.updated_at.to_datetime.utc
        answer.save
        expect(json).to eq(answer.attributes)
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