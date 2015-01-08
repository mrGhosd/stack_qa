require 'rails_helper'

feature "Unsigned user", :js do
  let!(:user){ create :user }
  let!(:question){ create :question, user_id: user.id }
  let!(:comment) { create :comment, user_id: user.id, question_id: question.id }

  scenario "see list of comments" do
    visit root_path
    click_link("#{question.title}")
    expect(page).to have_content(comment.text)
  end
end