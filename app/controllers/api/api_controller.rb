class Api::ApiController < ApplicationController
  skip_authorize_resource
  before_action :doorkeeper_authorize!
end