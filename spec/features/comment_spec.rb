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
end