require 'rails_helper'

feature "User", :js do
  let!(:user) { create :user }
  let!(:category) { create :category }
  let!(:question) { create :question, user_id: user.id, category_id: category.id }

  before do
    sign_in user
  end

  context "Question" do
    scenario "create complaint" do
      visit question_path(question)
      find('.complain-question', match: :first).click
      expect(page).to have_css(".complain_message")
    end
  end

  context "Answer" do
    let!(:answer) { create :answer, question_id: question.id, user_id: user.id }
    scenario "create complaint" do
      visit question_path(question)
      find('.complain-answer', match: :first).click
      expect(page).to have_css(".complain_message")
    end
  end
end