class RegistrationsController < Devise::RegistrationsController
  skip_authorize_resource
  respond_to :html, :json
end
