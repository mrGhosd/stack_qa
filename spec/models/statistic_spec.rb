require 'rails_helper'

describe Statistic do
  let!(:user) { create :user }
  let!(:question) { create :question, user_id: user.id }
  it { should belong_to :user }

  describe "#answer_rate" do
    context "increase answers count anyway" do
      let!(:diff_question) { create :question }
      let!(:diff_answer) { create :answer, user_id: user.id, question_id: diff_question.id }
      let!(:answer) { create :answer, user_id: user.id, question_id: diff_question.id }

      it "update answers_count attribute" do
        user.statistic.answer_rate(user, answer)
        expect(user.statistic.rate).to eq(1)
        expect(user.statistic.answers_count).to eq(1)
      end
    end

    context "user's answer is first on this question" do

      let!(:diff_question) { create :question }
      let!(:answer) { create :answer, user_id: user.id, question_id: diff_question.id }

      it "update first_answers_count attribute" do
        user.statistic.answer_rate(user, answer)
        expect(user.statistic.rate).to eq(2)
        expect(user.statistic.first_answers_count).to eq(1)
      end
    end

    context "user first answered on his own question" do
      let!(:answer) { create :answer, user_id: user.id, question_id: question.id }
      it "update first_self_answers_count attribute" do
        user.statistic.answer_rate(user, answer)
        expect(user.statistic.rate).to eq(7)
        expect(user.statistic.first_self_answers_count).to eq(1)
      end
    end

    context "user answered on his own question, but not first" do
      let!(:diff_answer) { create :answer, user_id: user.id, question_id: question.id }
      let!(:answer) { create :answer, user_id: user.id, question_id: question.id }
      it "update self_answers_count attribute" do
        user.statistic.answer_rate(user, answer)
        expect(user.statistic.rate).to eq(3)
        expect(user.statistic.self_answers_count).to eq(1)
      end
    end
  end

  describe "#callback_rate" do
    let!(:answer){ create :answer, user_id: user.id, question_id: question.id }
    context "positive rate on question" do
      it "update questions_positive_rate_count attribute" do
        user.statistic.callback_rate(user, question, "plus")
        expect(user.statistic.questions_positive_rate_count).to eq(1)
        expect(user.statistic.rate).to eq 2
      end
    end

    context "positive rate on answer" do
      it "update answers_positive_rate_count attribute" do
        user.statistic.callback_rate(user, answer, "plus")
        expect(user.statistic.answers_positive_rate_count).to eq(1)
        expect(user.statistic.rate).to eq 1
      end
    end

    context "negative rate on question" do
      it "update questions_negative_rate_count attribute" do
        user.statistic.callback_rate(user, question, "minus")
        expect(user.statistic.questions_negative_rate_count).to eq(1)
        expect(user.statistic.rate).to eq -2
      end
    end

    context "negative rate on answer" do
      it "update answers_negative_rate_count attribute" do
        user.statistic.callback_rate(user, answer, "minus")
        expect(user.statistic.answers_negative_rate_count).to eq(1)
        expect(user.statistic.rate).to eq -1
      end
    end
  end
end