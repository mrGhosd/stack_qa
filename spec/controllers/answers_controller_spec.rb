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
        answer: attributes_for(:answer, user_id: subject.current_user.id,
        question_id: question.id)}.to change(Answer, :count).by(1)
      end

      it "return just created answer" do
        post :create, question_id: question.id, answer: attributes_for(:answer, question_id: question.id, user_id: subject.current_user.id)
        allow(PrivatePub).to receive("publish_to").and_return(Answer.first.to_json)
        expect(PrivatePub.publish_to).to eq(Answer.first.to_json)
      end
    end

    context "with invalid attributes" do
      it "doesn't create an answer" do
        expect{post :create,
        question_id: question.id,
        answer: attributes_for(:answer, user_id: subject.current_user.id,
        question_id: question.id, text: "")}.to change(Answer, :count).by(0)
      end

      it "return just created answer" do
        post :create, question_id: question.id, answer: attributes_for(:answer, question_id: question.id, user_id: subject.current_user.id, text: "")
        expect(JSON.parse(response.body)).to have_key("text")
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
        answer.reload
        expect(PrivatePub.publish_to).to eq(answer)
      end
    end

    context "with invalid attributes" do
      it "doesn't update answer attributes" do
        put :update, question_id: question.id, id: answer.id, answer: attributes_for(:answer, text: "")
        answer.reload
        expect(answer.text).to eq(answer.text)
      end

      it "return private_pub message, that contains the answer" do
        put :update, question_id: question.id, id: answer.id, answer: attributes_for(:answer, text: "")
        expect(JSON.parse(response.body)).to have_key("text")
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

  describe "POST #rate" do
    context "positive rate" do
      context "user doesn't voted on this answer" do
        it "increase answer's rate" do
          binding.pry
          post :rate, question_id: question.id, answer_id: answer.id, rate: "plus"
          answer.reload
          expect(answer.rate).to eq 1
        end
      end

      context "user voted on this question, but negative" do
        let!(:vote) { create :vote, user_id: subject.current_user.id, vote_id: question.id, vote_type: "Question", rate: -1 }
        before { question.update(rate: vote.rate) }
        it "increase question's rate" do
          post :rate, question_id: question.id, rate: "plus"
          question.reload
          expect(question.rate).to eq 0
        end
      end

      context "user voted this question positive" do
        let!(:vote) { create :vote, user_id: subject.current_user.id, vote_id: question.id, vote_type: "Question", rate: 1 }
        before { question.update(rate: vote.rate) }
        it "doesn't increase a question's rate" do
          post :rate, question_id: question.id, rate: "plus"
          question.reload
          expect(question.rate).to eq 1
        end
      end
    end

    context "negative rate" do
      context "user doesn't voted on this answer" do
        it "decrease answer's rate" do
          post :rate, question_id: question.id, rate: "minus"
          question.reload
          expect(question.rate).to eq -1
        end
      end

      context "user voted on this question positive" do
        let!(:vote) { create :vote, user_id: subject.current_user.id, vote_id: question.id, vote_type: "Question", rate: 1 }
        before { question.update(rate: vote.rate) }

        it "decrease question's rate" do
          post :rate, question_id: question.id, rate: "minus"
          question.reload
          expect(question.rate).to eq 0
        end
      end

      context "user vote on this question negative" do
        let!(:vote) { create :vote, user_id: subject.current_user.id, vote_id: question.id, vote_type: "Question", rate: -1 }
        before { question.update(rate: vote.rate) }

        it "decrease question's rate" do
          post :rate, question_id: question.id, rate: "minus"
          question.reload
          expect(question.rate).to eq question.rate
        end
      end
    end
  end
end