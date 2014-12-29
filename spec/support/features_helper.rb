require 'capybara/rails'

def sign_in(user)
  visit root_path
  click_link "Войти"
  within find("#new_user", match: :first) do
    fill_in 'Электронная почта:', with: user.email
    fill_in 'user_password', with: user.password
  end
  click_button "Отправить"
end