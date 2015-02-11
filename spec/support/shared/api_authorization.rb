shared_examples_for "API Authenticable" do
  context "unathorized" do
    it "returns 401 status if there is no access_token" do
      get api_path, format: :json
      expect(response.status).to eq(401)
    end

    it "returns 401 status if access_token is invalid" do
      get api_path, format: :json, access_token: '1234'
      expect(response.status).to eq(401)
    end
  end
end