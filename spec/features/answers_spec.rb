require 'rails_helper'

feature "Answers for unsigned user", :js do
  let!(:question) { create :question, :unclosed }
  scenario "doesn't show an link to answer creation" do
    visit root_path
    find(".question-item .title", match: :first).click
    expect(page).to have_content(question.title)
    expect(page).to_not have_content("Ответить...")
  end
end

feature "Answers for signed in user" do
  let!(:user) { create :user, :confirmed }
end