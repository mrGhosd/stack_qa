require 'rails_helper'

describe Question do
  it { should validate_presence_of :title }
  it { should validate_uniqueness_of :title }
  it { should validate_presence_of :text }
  it { should have_many :answers }
  it { should belong_to(:user) }
  it { should have_many :comments }
  it { should have_many :complaints }
  it { should have_many :question_users }
  it { should belong_to(:category) }
  it { should have_db_index :title }
  it { should have_db_index :is_closed }

  describe "scope .created_today" do
    let!(:questions_list) { create_list :question, 15 }

    it "return an value of created today questions" do
      expect(Question.created_today).to eq questions_list
    end
  end

  describe "scope .top" do
    let!(:pos_question) { create :question }
    let!(:neg_question) { create :question, rate: -1 }

    it "return a list of questions, sortered by an rate" do
      expect(Question.top).to eq([pos_question, neg_question])
    end
  end

  describe "#comments_sum" do
    let!(:question) { create :question }
    let!(:question_comment) { create :comment, commentable_id: question.id, commentable_type: question.class.to_s }


    context "question answers is not empty" do
      let!(:answer) { create :answer, question_id: question.id }
      let!(:answer_comment) { create :comment, commentable_id: answer.id, commentable_type: answer.class.to_s }

      it "return an count of comments in question + each answer comment count" do
        expect(question.comments_sum).to eq(question.comments.count + answer.comments.count)
      end
    end

    context "question doesn't have any answer" do
      it "return only question comments count" do
        expect(question.comments_sum).to eq(question.comments.count)
      end
    end

  end
end