require 'rails_helper'

feature "Unlogined user", :js do
  scenario "registration with valid parameters" do
    visit root_path
    click_link "Регистрация"
    within "#new_user" do
      fill_in 'Электронная почта:', with: 'ashout@mail.ru'
      fill_in 'user_password', with: 'myCurrentPassword'
      fill_in 'user_password_confirmation', with: 'myCurrentPassword'
    end
    click_button "Отправить"
    sleep 1
    expect(page).to have_content("Выйти")
  end

  scenario "registration with invalid parameters" do
    visit root_path
    click_link "Регистрация"
    within "#new_user" do
      fill_in 'Электронная почта:', with: 'ashout@mail.ru'
      fill_in 'user_password', with: 'myCurrent'
      fill_in 'user_password_confirmation', with: 'myCurrentPassword'
    end
    click_button "Отправить"
    expect(page).to have_content("doesn't match Password")
  end
end

feature "Existing user", :js do
  let!(:user) { create :user, :confirmed }
  scenario "Logging in with correct data" do
    visit root_path
    click_link "Войти"
    within "#new_user" do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
    end
    click_button "Отправить"
    sleep 1
    expect(page).to have_content("Выйти")
  end

  scenario "Logging in with incorrect data" do
    visit root_path
    click_link "Войти"
    within "#new_user" do
      fill_in 'Электронная почта:', with: "awdawdawdaw"
      fill_in 'user_password', with: user.password
    end
    click_button "Отправить"
    expect(page).to have_content("Invalid email or password")
  end


end

feature "Edit profile", :js do
  let!(:user) { create :user, :confirmed }

  before do
    sign_in user
    sleep 1
  end

  context "with valid attributes" do
    scenario "updating" do
      visit user_path(user)
      find(".edit-user", match: :first).click
      fill_in "user_surname", with: "newSurName"
      fill_in "user_name", with: "newName"
      find(".save-user", match: :first).click
      expect(page).to have_content("newSurName")
    end
  end

  context "with invalid attributes" do
    scenario "doesn't update" do
      visit user_path(user)
      find(".edit-user", match: :first).click
      fill_in "user_surname", with: "newSurName"
      fill_in "user_email", with: ""
      find(".save-user", match: :first).click
      expect(page).to have_content("can't be blank")
    end
  end
end

