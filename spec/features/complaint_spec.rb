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

  context "Comment" do
    let!(:comment) { create :comment, commentable_id: question.id, commentable_type: question.class.to_s, user_id: user.id }
    scenario "create complaint" do
      visit question_path(question)
      find('.complain-comment', match: :first).click
      expect(page).to have_css(".complain_message")
    end
  end
end

feature "Admin", :js do
  let!(:user) { create :user }
  let!(:category) { create :category }
  let!(:question) { create :question, user_id: user.id, category_id: category.id }
  let!(:complaint) { create :complaint, complaintable_type: question.class.to_s, complaintable_id: question.id, user_id: user.id }

  before do
    sign_in user
  end

  scenario "visit admin complaint_path and see a list of complaints" do
    visit admin_complaints_path
    expect(page).to have_content(question.title)
    expect(page).to have_content(user.correct_naming)
  end

  scenario "delete a complaint" do
    visit admin_complaints_path
    find(".delete-complaint", match: :first).click
    expect(page).to_not have_content(question.title)
    expect(page).to_not have_content(user.correct_naming)
  end
end