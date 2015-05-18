class Api::ApiController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :set_locale
  respond_to :json

  protected

  def set_locale
    I18n.locale = params[:device_locale] || I18n.default_locale
  end

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end