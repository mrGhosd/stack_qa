require 'capybara/rails'

def sign_in(user)
  visit root_path
  click_link "Войти"
  within find("#new_user", match: :first) do
    fill_in 'user_email', with: user.email
    sleep 1
    fill_in 'user_password', with: user.password
    sleep 1
  end
  click_button "Отправить"
end

def fill_redactor_editor(id, text)
  page.execute_script %Q{
      $('.redactor_editor').text(#{text});
      $('##{id}').val(#{text});
    }
end