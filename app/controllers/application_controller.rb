class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end
  authorize_resource

  def widget_data
    Widget.switch_view(params[:current_filter], params[:direction])
  end

  def set_locale
    I18n.locale = cookies[:locale] || session[:locale] || I18n.default_locale
  end

end
