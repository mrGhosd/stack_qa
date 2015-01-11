require 'rails_helper'

feature "Admin", :js do
  let!(:admin){ create :user, :admin }
  let!(:category) { create :category }

  before do
    sign_in admin
    click_link("Админка")
  end

  scenario "Create a new category" do
    click_link "Создать"
    within "#new_category" do
      fill_in "category_title", with: "TITLE"
      fill_in "category_description", with: "DESCRIPTION"
      attach_file "category_image", "#{Rails.root}/app/assets/images/Ruby_on_Rails.png"
      click_button "Сохранить"
    end
    sleep 1
    expect(page).to have_content("DESCRIPTION")
  end
end