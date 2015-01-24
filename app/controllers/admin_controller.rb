class AdminController < ApplicationController
  skip_authorize_resource
  before_filter :check_admin
  layout 'admin'

  def check_admin
    redirect_to root_path unless current_user && current_user.is_admin?
  end
end