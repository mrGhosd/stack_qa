require 'rails_helper'

describe Question do
  it { should validate_presence_of :title }
  it { should validate_uniqueness_of :title }
  it { should validate_presence_of :text }
  it { should have_many :answers }
  it { should belong_to(:user) }
  it { should have_many :comments }
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
end