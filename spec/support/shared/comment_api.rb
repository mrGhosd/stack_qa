shared_examples_for "comment_api" do
  let!(:comment) { create :comment, user_id: user.id, commentable_id: entity.id, commentable_type: entity.class.to_s }

  describe "GET #index" do
    it "return comments_list for entity" do
      binding.pry
      get url, access_token: access_token.token
      expect(response.body).to eq(comment.as_json(methods: [:question, :answer, :user]))
    end
  end

  describe "POST #create" do

  end

  describe "PUT #update" do

  end

  describe "DELETE #destroy" do

  end
end