require 'rails_helper'

describe "Profile API" do
  describe "GET /me" do
    let!(:api_path) { "/api/v1/profiles/me" }
    it_behaves_like "API Authenticable"

    context "authorized" do
      let!(:me){ create :user }
      let!(:access_token) { create :access_token, resource_owner_id: me.id }

      before do
        get "/api/v1/profiles/me", format: :json, access_token: access_token.token
      end

      it "return 200 status" do
        expect(response).to be_success
      end

      it "contains email" do
        expect(response.body).to be_json_eql(me.email.to_json).at_path('email')
      end

      it "containes id" do
        expect(response.body).to be_json_eql(me.id.to_json).at_path('id')
      end

      it "does not contain password" do
        expect(response.body).to_not have_json_path('password')
      end

      it "does not containe encrypted passwrd" do
        expect(response.body).to_not have_json_path('encrypted_password')
      end
    end
  end

  describe "GET #index" do
    let!(:current_user){ create :user }
    let!(:access_token) { create :access_token, resource_owner_id: current_user.id }
    let!(:users) { create_list(:user, 15) }
    let!(:user) { users.first }
    before { get "/api/v1/profiles", format: :json, access_token: access_token.token }

    it "return 200 status" do
      expect(response).to be_success
    end

    it "return list of users except current resource owner" do
      expect(response.body).to be_json_eql(User.where.not(id: current_user.id).to_json)
    end

    %w(id surname name created_at updated_at).each do |attr|
      it "user object contains #{attr}" do
        expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("0/#{attr}")
      end
    end
  end
end