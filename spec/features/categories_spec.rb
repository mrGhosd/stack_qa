require 'rails_helper'

feature "Admin", :js do
  let!(:admin){ create :user, :admin }
  let!(:category) { create :category }

  before do
    sign_in admin
    click_link("Админка")
  end

  context "with valid attributes" do
    scenario "Create a new category" do
      click_link "Создать"
      within ".category-form" do
        fill_in "category_title", with: "TITLE"
        page.execute_script %Q{
        $('.redactor_editor').text('1');
        $("#category_description").val('1');
      }
        attach_file "category_image", "#{Rails.root}/app/assets/images/Ruby_on_Rails.png"
        click_button "Сохранить"
      end
      sleep 1
      expect(page).to have_content("TITLE")
    end
  end

  context "with invalid attributes" do
    scenario "Create a new category" do
      click_link "Создать"
      within "#new_category" do
        fill_in "category_title", with: ""
        page.execute_script %Q{
        $('.redactor_editor').text('1');
        $("#category_description").val('1');
      }
        attach_file "category_image", "#{Rails.root}/app/assets/images/Ruby_on_Rails.png"
        click_button "Сохранить"
      end
      sleep 1
      expect(page).to have_css(".error")
      expect(page).to have_css(".error-text")
      expect(page).to have_content("can't be blank")
    end
  end

end