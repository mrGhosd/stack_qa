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

    scenario "Update existing category" do
      find(".row.actions .btn.btn-success", match: :first).click
      within ".category-form" do
        fill_in "category_title", with: "EDIT_TITLE"
        attach_file "category_image", "#{Rails.root}/app/assets/images/Ruby_on_Rails.png"
        click_button "Сохранить"
      end
      sleep 1
      expect(page).to have_content("EDIT_TITLE")
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
      sleep 0.1
      expect(page).to have_css(".error")
      expect(page).to have_css(".error-text")
      expect(page).to have_content("can't be blank")
    end

    scenario "Update existing category" do
      find(".row.actions .btn.btn-success", match: :first).click
      within ".category-form" do
        fill_in "category_title", with: ""
        click_button "Сохранить"
      end
      sleep 0.1
      expect(page).to have_css(".error")
      expect(page).to have_css(".error-text")
      expect(page).to have_content("can't be blank")
    end
  end

  scenario "delete category" do
    find(".row.actions .btn.btn-danger", match: :first).click
    sleep 1
    expect(page).to_not have_content(category.title)
  end
end

feature "User", :js do
  let!(:user){ create :user }
  let!(:category) { create :category }
  let!(:question) { create :question, user_id: user.id, category_id: category.id }

  before do
    sign_in user
    click_link "Категории"
  end

  scenario "see the list of categories" do
    expect(page).to have_content(category.title)
  end

  scenario "show category full info" do
    find(".category-title", match: :first).click
    expect(page).to have_content(category.title)
    expect(page).to have_content(category.description)
  end

  scenario "hide and show category description" do
    find(".category-title", match: :first).click
    find(".toggle-description").click
    sleep 0.1
    expect(page).to_not have_content category.description
    find(".toggle-description").click
    sleep 0.1
    expect(page).to have_content category.description
  end

  scenario "show questions for current category" do
    find(".category-title", match: :first).click
    expect(page).to have_content(question.title)
  end
end