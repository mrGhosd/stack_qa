require 'rails_helper'

describe "Question" do
  feature "Unsigned user", :js do
    let!(:user){ create :user }
    let!(:question){ create :question, user_id: user.id }
    let!(:comment) { create :comment, user_id: user.id, commentable_id: question.id, commentable_type: "Question" }

    before do
      visit root_path
      click_link(".question-item .title", match: :first)
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
    let!(:comment) { create :comment, user_id: user.id, commentable_id: question.id, commentable_type: "Question" }

    before do
      sign_in user
      click_link("#{question.title}")
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
          fill_in "text", with: "TEXT"
          click_button "Отправить"
        end
        expect(page).to have_content("TEXT")
      end

      scenario "update an existed comment" do
        find(:css, ".edit-comment").click
        expect(page).to have_css(".comment-form")
        within ".comment-form" do
          fill_in "text", with: "OLOLO"
          click_button "Отправить"
        end
        expect(page).to have_content("OLOLO")
      end
    end

    context "with invalid attributes" do
      scenario "create a new comment" do
        find(:css, ".add-comment").click
        expect(page).to have_css(".comment-form")
        within ".comment-form" do
          click_button "Отправить"
        end
        expect(page).to have_css(".error")
        expect(page).to have_css(".error-text")
        expect(page).to have_content("can't be blank")
      end

      scenario "update an existed comment" do
        find(:css, ".edit-comment").click
        expect(page).to have_css(".comment-form")
        within ".comment-form" do
          fill_in "text", with: ""
          click_button "Отправить"
        end
        expect(page).to have_css(".error")
        expect(page).to have_css(".error-text")
        expect(page).to have_content("can't be blank")
      end
    end

    scenario "delete existing comment" do
      find(:css, ".remove-comment").click
      sleep 0.2
      expect(page).to_not have_content(comment.text)
    end

  end
end