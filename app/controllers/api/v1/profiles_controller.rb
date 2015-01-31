module Api
  module V1
    class ProfilesController < Api::ApiController
      before_action :doorkeeper_authorize!
      respond_to    :json

      def me
        render nothing: true
      end
    end
  end
end

