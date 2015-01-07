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

