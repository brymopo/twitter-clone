require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe "validations" do
    context "presence" do
      %i[email username full_name password].each do |attr|
        it { is_expected.to validate_presence_of(attr) }
      end
    end

    context "uniqueness" do
      subject { build(:user) }

      it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
      it { should validate_uniqueness_of(:username).ignoring_case_sensitivity }
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:tweets).dependent(:destroy) }
    it { is_expected.to have_many(:followers) }
    it { is_expected.to have_many(:following) }
  end

  describe "followers_count" do
    it "default is 0" do
      expect(user).to be_valid
      expect(user.followers_count).to eq(0)
    end

    it "reflects the right number of followers" do
      followers = create_list(:user, 5)
      followers.each do |follower|
        expect(follower).to be_valid
        Follow.create(follower_id: follower.id, followed_id: user.id)
      end
      expect(user.reload.followers_count).to eq(5)
      expect(user.followers).to match_array(followers)
    end
  end

  describe "following_count" do
    it "default is 0" do
      expect(user).to be_valid
      expect(user.following_count).to eq(0)
    end

    it "reflects the right number of users followed" do
      followees = create_list(:user, 5)
      followees.each do |followee|
        expect(followee).to be_valid
        Follow.create(follower_id: user.id, followed_id: followee.id)
      end
      expect(user.reload.following_count).to eq(5)
      expect(user.following).to match_array(followees)
    end
  end
end
