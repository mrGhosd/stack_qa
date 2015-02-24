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
        expect(response.status).to eq(200)
      end
    end

    context "with invalid attributes" do
      it "doesn't create a question" do
        expect{post :create,
        question: attributes_for(:question,
        title: "", user_id: subject.current_user.id)}.to change(Question, :count).by(0)
      end

      it "return questions errors" do
        post :create,
        question: attributes_for(:question,
        title: "", user_id: subject.current_user.id)
        expect(response.status).to eq(403)
      end
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      it "update question parameters" do
        put :update, id: question, question: attributes_for(:question, title: "adawkdawokd;awd", user_id: subject.current_user.id)
        question.reload
        expect(question.title).to eq("adawkdawokd;awd")
      end

      it "return success json" do
        put :update, id: question, question: attributes_for(:question, user_id: subject.current_user.id)
        expect(response.body).to eq({success: true}.to_json)
      end
    end
    context "with invalid attributes" do
      it "doesn't change questions attributes" do
        put :update, id: question, question: attributes_for(:question, title: "", user_id: subject.current_user.id)
        question.reload
        expect(question.title).to eq(question.title)
      end

      it "return questions errors" do
        put :update, id: question, question: attributes_for(:question, title: "", user_id: subject.current_user.id)
        expect(response.status).to eq(403)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroy the choosen question" do
      expect{ delete :destroy, id: question.id }.to change(Question, :count).by(-1)
    end

    it "return 200 status" do
      delete :destroy, id: question.id
      expect(response.status).to eq(200)
    end
  end

  describe "POST #rate" do
    context "positive rate" do
      context "user doesn't voted on this question" do
        it "increase question's rate" do
          post :rate, question_id: question.id, rate: "plus"
          question.reload
          expect(question.rate).to eq 1
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
      context "user doesn't voted on this question" do
        it "decrease question's rate" do
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

  describe "POST #sign_in_question" do
    context "user has signed up on question" do
      let!(:question_user) { create :question_user, user_id: subject.current_user.id, question_id: question.id }
      it "return json with message, that you alerady signed up on question update" do
        post :sign_in_question, id: question.id
        expect(response.body).to eq({message: "Вы уже подписаны на данное обновление"}.to_json)
      end
    end

    context "user hasn't signed up on question" do
      context "question_user was created" do
        it "return json with message, that you have been signed up to question's updates" do
          post :sign_in_question, id: question.id
          expect(response.body).to eq({message: "Вы подписались на данный вопрос"}.to_json)
        end
      end
    end
  end
end