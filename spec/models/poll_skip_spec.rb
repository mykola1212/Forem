require "rails_helper"

RSpec.describe PollSkip, type: :model do
  let(:article) { create(:article, featured: true) }
  let(:user) { create(:user) }
  let(:poll) { create(:poll, article: article) }

  context "when user has already voted (or skipped) on the poll" do
    it "is invalid" do
      vote = build(:poll_skip, user: user, poll: poll)
      allow(vote.poll).to receive(:vote_previously_recorded_for?).with(user_id: user.id).and_return(true)

      expect(vote).not_to be_valid
      expect(vote.errors[:base]).to include("cannot vote more than once in one poll")
    end
  end

  context "when user has not voted nor skipped the poll" do
    it "is valid" do
      vote = build(:poll_skip, user: user, poll: poll)
      allow(vote.poll).to receive(:vote_previously_recorded_for?).with(user_id: user.id).and_return(false)

      expect(vote).to be_valid
      expect(vote.errors[:base]).to be_empty
    end
  end
end
