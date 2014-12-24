require 'rails_helper'

feature "User", :js do
  let!(:question) { create :question, :unclosed }
  scenario "see the questions" do
    visit root_path
    binding.pry
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.text)
  end
end