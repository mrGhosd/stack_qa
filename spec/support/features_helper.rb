require 'capybara/rails'

module FeatureHelper
  def sign_in(user)
    visit root_path
    find(".auth", match: :first).click
    within find("#new_user", match: :first) do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
    end
    find(".form-delegate", match: :first).click
  end

  def fill_redactor_editor(id, text)
    page.execute_script %Q{
      $('.redactor-editor').text("1");
    }
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end