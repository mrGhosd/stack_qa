require 'rails_helper'

describe "Profile API" do
  describe "GET /me" do
    context "unathorized" do
      it "returns 401 status if there is no access_token" do
        get "/api/v1/profiles/me", format: :json
        expect(response.status).to eq(401)
      end

      it "returns 401 status if access_token is invalid" do
        get "/api/v1/profiles/me", format: :json, access_token: '1234'
        expect(response.status).to eq(401)
      end
    end
  end
end