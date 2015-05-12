require 'rails_helper'

feature "Question for signed in user", :js do
  let!(:user) { create :user, :confirmed }
  let!(:category) { create :category }
  let!(:question) { create :question, :unclosed, user_id: user.id, category_id: category.id }

  before :each do
    sign_in user
  end

  scenario "see the questions" do
    expect(page).to have_content(question.title)
  end

  context "with valid attributes" do
    scenario "create a question" do
      click_link "Создать вопрос..."
      within "#new_question" do
        fill_in "question_title", with: "TEXT"
        fill_in "question_text", with: "2"
        select category.title, from: "question_category_id"
        click_button "Сохранить"
      end
      sleep 1
      expect(page).to have_content "TEXT"
    end
  end

  context "with invalid attributes" do
    scenario "doesn't create a question" do
      click_link "Создать вопрос..."
      within "#new_question" do
        fill_in "question_title", with: ""
        fill_in "question_text", with: "2"
        select category.title, from: "question_category_id"
        click_button "Сохранить"
      end
      sleep 1
      expect(page).to have_css(".error")
      expect(page).to have_css(".error-text")
      expect(page).to have_content("can't be blank")
    end

    scenario "doesn't update an question" do
      find(".glyphicon.glyphicon-pencil", match: :first).click
      expect(page).to have_content("Редактировать вопрос")
      within "form" do
        fill_in "question_title", with: ""
        fill_in "question_text", with: "2"
        select category.title, from: "question_category_id"
        click_button "Сохранить"
      end
      expect(page).to have_css(".error")
      expect(page).to have_css(".error-text")
      expect(page).to have_content("can't be blank")
    end
  end

  context "existed question was created by current user" do
    let!(:current_user_question) { create :question, :unclosed, title: "ololo", user_id: user.id, category_id: category.id }

    scenario "edit question" do
      find(".glyphicon.glyphicon-pencil", match: :first).click
      expect(page).to have_content("Редактировать вопрос")
      within "form" do
        fill_in "question_title", with: "5"
        fill_in "question_text", with: "2"
        select category.title, from: "question_category_id"
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
  let!(:category) { create :category }
  let!(:question) { create :question, :unclosed, category_id: category.id }
  scenario "cannot be answered or edited" do
    visit root_path
    expect(page).to have_content(question.title)
    find(".title", match: :first).click
    expect(page).to_not have_content("Ответить...")
  end
end