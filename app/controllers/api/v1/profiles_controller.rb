module Api
  module V1
    class ProfilesController < Api::ApiController
      respond_to    :json

      def me
        render nothing: true
      end
    end
  end
end

