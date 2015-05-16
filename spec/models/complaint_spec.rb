require 'rails_helper'

describe Complaint do
  it { should belong_to :user }
  it { should belong_to :complaintable }

  describe "#parent" do
    let!(:user) { create :user }
    let!(:category) { create :category }
    let!(:question) { create :question, user_id: user.id, category_id: category.id }
    let!(:answer) { create :answer, question_id: question.id, user_id: user.id }
    let!(:comment) { create :comment, commentable_id: question.id, commentable_type: question.class.to_s, user_id: user.id }

    context "Question" do
      let!(:complaint) { create :complaint, user_id: user.id, complaintable_id: question.id, complaintable_type: question.class.to_s }

      it "return question" do
        expect(complaint.parent).to eq(question)
      end
    end

    context "Answer" do
      let!(:complaint) { create :complaint, user_id: user.id, complaintable_id: answer.id, complaintable_type: answer.class.to_s }

      it "return question" do
        expect(complaint.parent).to eq(answer)
      end
    end

    context "Comment" do
      let!(:complaint) { create :complaint, user_id: user.id, complaintable_id: comment.id, complaintable_type: comment.class.to_s }

      it "return comment" do
        expect(complaint.parent).to eq(comment)
      end
    end

    context "Empty" do
      let!(:complaint) { create :complaint, user_id: user.id, complaintable_id: question.id, complaintable_type: "User" }

      it "return nil" do
        expect(complaint.parent).to eq(nil)
      end
    end
  end
end