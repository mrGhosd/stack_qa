require 'rails_helper'

feature "Answers for unsigned user", :js do
  let!(:question) { create :question, :unclosed }
  scenario "doesn't show an link to answer creation" do
    visit root_path
    find(".question-item .title", match: :first).click
    expect(page).to have_content(question.title)
    expect(page).to_not have_css(".add-answer")
  end
end

feature "Answers for signed in user", :js do
  let!(:user) { create :user, :confirmed }
  let!(:category) { create :category }
  let!(:question) { create :question, :unclosed, user_id: user.id, category_id: category.id }
  let!(:answer) { create :answer, user_id: user.id, question_id: question.id }

  before do
    sign_in user
    find(".question-item .title a", match: :first).click
  end

  scenario "is available from question page" do
    expect(page).to have_content(question.title)
    expect(page).to have_css(".add-answer")
  end

  context "with valid attributes" do
    scenario "create an answer" do
      find(".add-answer").click
      fill_in "answer_text", with: "POOOOO"
      find('.submit-answer').click
      expect(page).to have_content("POOOOO")
    end

    scenario "update question" do
      find(".edit-answer", match: :first).click
      fill_in "answer_text", with: "POOOOO"
      wait_for_ajax
      find('.submit-answer').click
      expect(page).to have_content("POOOOO")
    end
  end

  context "with invalid attributes" do
    scenario "doesn't create an answer" do
      find(".add-answer").click
      fill_in "answer_text", with: ""
      find('.submit-answer').click
      expect(page).to have_content("can't be blank")
    end
  end

  scenario "delete answer" do
    find(".remove-answer", match: :first).click
    expect(page).to_not have_content(answer.text)
  end

  scenario "mark answer as helpfull" do
    find(".answer-is-helpfull", match: :first).click
    wait_for_ajax
    expect(page).to have_css(".correct-answer-icon")
  end

end