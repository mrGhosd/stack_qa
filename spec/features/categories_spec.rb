require 'rails_helper'

feature "Admin", :js do
  let!(:admin){ create :user, :admin }
  let!(:category) { create :category }

  before do
    sign_in admin
    find(".admin-page").click
  end

  context "with valid attributes" do
    scenario "Create a new category" do
      find(".category-create").click
      within ".category-form" do
        fill_in "category_title", with: "TITLE"
        fill_in "category_description", with: "1"
        attach_file "category_image", "#{Rails.root}/app/assets/images/Ruby_on_Rails.png"
        find(".submit-category").click
      end
      wait_for_ajax
      expect(page).to have_content("TITLE")
    end

    scenario "Update existing category" do
      find(".row.actions .btn.btn-success", match: :first).click
      within ".category-form" do
        fill_in "category_title", with: "EDIT_TITLE"
        attach_file "category_image", "#{Rails.root}/app/assets/images/Ruby_on_Rails.png"
        find(".submit-category").click
      end
      wait_for_ajax
      expect(page).to have_content("EDIT_TITLE")
    end
  end

  context "with invalid attributes" do
    scenario "Create a new category" do
      find(".category-create").click
      within "#new_category" do
        fill_in "category_title", with: ""
        fill_in "category_description", with: "1"
        attach_file "category_image", "#{Rails.root}/app/assets/images/Ruby_on_Rails.png"
        find(".submit-category").click
      end
      wait_for_ajax
      expect(page).to have_css(".error")
      expect(page).to have_css(".error-text")
    end

    scenario "Update existing category" do
      find(".row.actions .btn.btn-success", match: :first).click
      within ".category-form" do
        fill_in "category_title", with: ""
        find(".submit-category").click
      end
      wait_for_ajax
      expect(page).to have_css(".error")
      expect(page).to have_css(".error-text")
    end
  end

  scenario "delete category" do
    find(".row.actions .btn.btn-danger", match: :first).click
    wait_for_ajax
    expect(page).to_not have_content(category.title)
  end
end

feature "User", :js do
  let!(:user){ create :user }
  let!(:category) { create :category }
  let!(:question) { create :question, user_id: user.id, category_id: category.id }

  before do
    sign_in user
    find(".categories-list").click
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
    wait_for_ajax
    expect(page).to_not have_content category.description
    find(".toggle-description").click
    wait_for_ajax
    expect(page).to have_content category.description
  end

  scenario "show questions for current category" do
    find(".category-title", match: :first).click
    expect(page).to have_content(question.title)
  end
end