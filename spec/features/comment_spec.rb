require 'rails_helper'

feature "Unsigned user", :js do
  let!(:user){ create :user }
  let!(:question){ create :question, user_id: user.id }
  let!(:comment) { create :comment, user_id: user.id, question_id: question.id }

  before do
    visit root_path
    click_link("#{question.title}")
  end

  scenario "see list of comments" do
    expect(page).to have_content(comment.text)
  end

  scenario "doesn't see a link for adding a new comment" do
    expect(page).to_not have_content(".glyphicon.glyphicon-comment")
  end
end

feature "Signed in user", :js do
  let!(:user){ create :user }
  let!(:question){ create :question, user_id: user.id }
  let!(:comment) { create :comment, user_id: user.id, question_id: question.id }

  before do
    sign_in user
    click_link("#{question.title}")
  end

  scenario "see link for adding an comment" do
    expect(page).to have_css(".glyphicon.glyphicon-comment")
  end

  scenario "show new comment form" do
    find(:css, ".add-comment").click
    expect(page).to have_css(".comment-form")
  end
  context "with valid attributes" do
    scenario "create a new comment" do
      find(:css, ".add-comment").click
      expect(page).to have_css(".comment-form")
      within ".comment-form" do
        fill_in "comment_text", with: "TEXT"
        click_button "Отправить"
      end
      sleep 1
      expect(page).to have_content("TEXT")
    end
  end

  context "with invalid attributes" do
    scenario "create a new comment" do
      find(:css, ".add-comment").click
      expect(page).to have_css(".comment-form")
      within ".comment-form" do
        click_button "Отправить"
      end
      sleep 1
      expect(page).to have_css(".error")
      expect(page).to have_css(".error-text")
      expect(page).to have_content("can't be blank")
    end
  end

end