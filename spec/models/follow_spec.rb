require 'rails_helper'

RSpec.describe Follow, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:follower_id) }
    it { is_expected.to validate_presence_of(:followed_id) }
    
    context "uniqueness" do
      let(:user1) { create(:user) }
      let(:user2) { create(:user) }

      subject(:follow) do
        Follow.create(followed_id: user2.id, follower_id: user1.id)
      end

      before { subject }

      it "allows user1 to follow user2" do
        expect(follow).to be_valid
        expect(follow.followed_id).to eq(user2.id)
        expect(follow.follower_id).to eq(user1.id)
      end

      it "allow user2 to follow user1 back" do
        follow_back = Follow.create(followed_id: user1.id, follower_id: user2.id)

        expect(follow).to be_valid
        expect(follow_back).to be_valid
        expect(follow_back).not_to eq(follow)
        expect(follow_back.followed_id).to eq(user1.id)
        expect(follow_back.follower_id).to eq(user2.id)
      end

      it "invalid when user1 already follows user2" do
        follow_back = Follow.create(followed_id: user2.id, follower_id: user1.id)

        expect(follow).to be_valid
        expect(follow_back).not_to be_valid
        expect(follow_back).not_to eq(follow)
        expect(follow_back.followed_id).to eq(user2.id)
        expect(follow_back.follower_id).to eq(user1.id)
      end

      it "invalid when follower_id and followed_id are equal" do
        follow_back = Follow.create(followed_id: user1.id, follower_id: user1.id)

        expect(follow).to be_valid
        expect(follow_back).not_to be_valid
        expect(follow_back).not_to eq(follow)
        expect(follow_back.followed_id).to eq(user1.id)
        expect(follow_back.follower_id).to eq(user1.id)
      end
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:follower).class_name("User").with_foreign_key("follower_id") }
    it { is_expected.to belong_to(:followed).class_name("User").with_foreign_key("followed_id") }
  end
end
