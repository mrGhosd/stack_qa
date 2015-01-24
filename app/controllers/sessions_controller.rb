class SessionsController < Devise::SessionsController
  skip_authorize_resource
  respond_to :html, :json
end
