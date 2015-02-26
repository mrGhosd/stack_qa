shared_examples_for "rate" do
  context "positive rate" do
    context "user doesn't voted on this question" do
      it "increase question's rate" do
        post :rate, params.merge({rate: "plus"})
        object.reload
        expect(object.rate).to eq 1
      end
    end

    context "user voted on this question, but negative" do
      let!(:vote){ create :vote, user_id: subject.current_user.id, vote_id: object.id, vote_type: object.class.to_s, rate: -1 }
      before { object.update(rate: vote.rate) }
      it "increase question's rate" do
        post :rate, params.merge({rate: "plus"})
        object.reload
        expect(object.rate).to eq 0
      end
    end

    context "user voted this question positive" do
      let!(:vote) { create :vote, user_id: subject.current_user.id, vote_id: object.id, vote_type: object.class.to_s, rate: 1 }
      before { object.update(rate: vote.rate) }
      it "doesn't increase a question's rate" do
        post :rate, params.merge({rate: "plus"})
        object.reload
        expect(object.rate).to eq 1
      end
    end
  end

  context "negative rate" do
    context "user doesn't voted on this question" do
      it "decrease question's rate" do
        post :rate, params.merge({rate: "minus"})
        object.reload
        expect(object.rate).to eq -1
      end
    end

    context "user voted on this question positive" do
      let!(:vote) { create :vote, user_id: subject.current_user.id, vote_id: object.id, vote_type: object.class.to_s, rate: 1 }
      before { object.update(rate: vote.rate) }

      it "decrease question's rate" do
        post :rate, params.merge({rate: "minus"})
        object.reload
        expect(object.rate).to eq 0
      end
    end

    context "user vote on this question negative" do
      let!(:vote) { create :vote, user_id: subject.current_user.id, vote_id: object.id, vote_type: object.class.to_s, rate: -1 }
      before { question.update(rate: vote.rate) }

      it "decrease question's rate" do
        post :rate, params.merge({rate: "minus"})
        object.reload
        expect(object.rate).to eq object.rate
      end
    end
  end
end