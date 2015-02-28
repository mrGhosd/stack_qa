require 'rails_helper'

describe Comment do
  it { should belong_to :user }
  it { should belong_to :commentable }

  describe "#question" do
    context "type is Question" do
      let!(:question) { create :question }
      let!(:comment) { create :comment, commentable_type: question.class.to_s, commentable_id: question.id }

      it "return an question" do
        expect(comment.question).to eq(question)
      end
    end

    context "type is Answer" do
      let!(:question){ create :question }
      let!(:answer) { create :answer, question_id: question.id }
      let!(:comment) { create :comment, commentable_type: answer.class.to_s, commentable_id: answer.id }

      it "return an answer's question" do
        expect(comment.question).to eq question
      end
    end
  end

  describe "#author" do
    let!(:user) { create :user }
    let!(:comment) { create :comment, user_id: user.id }

    it "return string that contains correct author name" do
      expect(comment.author).to eq("#{user.surname} #{user.name}")
    end
  end

  describe "#humanized_date" do

  end
end