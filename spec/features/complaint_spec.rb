require 'rails_helper'

feature "User", :js do
  let!(:user) { create :user }
  let!(:category) { create :category }
  let!(:question) { create :question, user_id: user.id, category_id: category.id }

  context "Question" do
    before do
      sign_in user
    end

    scenario "create complaint" do
      visit question_path(question)
      find('.complain-question', match: :first).click
      expect(page).to have_css(".complain_message")
    end
  end
end