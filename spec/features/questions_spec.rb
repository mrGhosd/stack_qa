require 'rails_helper'

feature "Question for signed in user", :js do
  let!(:user) { create :user, :confirmed }
  let!(:question) { create :question, :unclosed, user_id: user.id }


  before :each do
    sign_in user
  end

  scenario "see the questions" do
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.text)
  end

  scenario "create a question" do
    click_link "Создать вопрос..."
    within "#new_question" do
      fill_in "question_title", with: "TEXT"
      fill_redactor_editor("question_text", "2")
      click_button "Сохранить"
    end
    sleep 1
    expect(page).to have_content "TEXT"
  end

  context "existed question was created by current user" do
    let!(:current_user_question) { create :question, :unclosed, title: "ololo", user_id: user.id }

    scenario "edit question" do
      find(".glyphicon.glyphicon-pencil", match: :first).click
      expect(page).to have_content("Редактировать вопрос")
      within "form" do
        fill_in "question_title", with: "5"
        fill_redactor_editor("question_text", "2")
        click_button "Сохранить"
      end
      expect(page).to have_content "5"
    end

    scenario "delete question" do
      find(".glyphicon.glyphicon-remove", match: :first).click
      sleep 1
      expect(page).to_not have_content(question.title)
    end
  end
end

feature "Question for unsigned in user", :js do
  let!(:question) { create :question, :unclosed }
  scenario "cannot be answered or edited" do
    visit root_path
    expect(page).to have_content(question.title)
    find(".title", match: :first).click
    expect(page).to_not have_content("Ответить...")
  end
end