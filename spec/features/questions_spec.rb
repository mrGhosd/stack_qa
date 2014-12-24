require 'rails_helper'

feature "User", :js do

  let!(:question) { create :question, :unclosed }

  before do
    visit root_path
  end

  scenario "see the questions" do
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.text)
  end

  scenario "create a question" do
    click_link "Создать вопрос..."
    within "#new_question" do
      fill_in "question_title", with: "1"
      fill_in "question_text", with: "2"
      click_button "Сохранить"
    end
    sleep 1
    expect(page).to have_content "1"
  end

  scenario "edit question" do
    find(".glyphicon.glyphicon-pencil", match: :first).click
    expect(page).to have_content("Редактировать вопрос")
    within "form" do
      fill_in "question_title", with: "5"
      fill_in "question_text", with: "6"
      click_button "Сохранить"
    end
    sleep 1
    expect(page).to have_content "6"
  end

  scenario "delete question" do
    find(".glyphicon.glyphicon-remove", match: :first).click
    sleep 1
    expect(page).to_not have_content(question.title)
  end
end