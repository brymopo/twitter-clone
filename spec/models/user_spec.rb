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

  describe "scopes" do
    describe "alphabetical" do
      let(:user) { create(:user) }
      let(:names) do
        [
          "John Doe",
          "Pedro Perez",
          "Andrea Gonzalez",
          "Andres Zapata",
          "Maria Bravo"
        ]
      end
      let(:in_order) do
        [
          "Andrea Gonzalez",
          "Andres Zapata",
          "John Doe",
          "Maria Bravo",
          "Pedro Perez"
        ]
      end
      let(:users) { names.map { |name| create(:user, full_name: name) } }

      context "followers" do
        before do
          users.each do |u|
            follow = Follow.create(follower_id: u.id, followed_id: user.id)
            expect(follow).to be_valid
          end
        end

        subject { user.followers.alphabetical.pluck(:full_name) }

        it { is_expected.to eq(in_order) }
      end

      context "following" do
        before do
          users.each do |u|
            follow = Follow.create(follower_id: user.id, followed_id: u.id)
            expect(follow).to be_valid
          end
        end

        subject { user.following.alphabetical.pluck(:full_name) }

        it { is_expected.to eq(in_order) }
      end
    end

    describe "tweets_feed" do
      let(:users_list) { create_list(:user, 5) }
      let(:user) { create(:user) }
      let!(:user_tweets) { create_list(:tweet, 5, user: user) }
      let!(:following_tweets) { users_list.map { |u| create_list(:tweet, 5, user: u) } }

      before do
        users_list.each do |u|
          follow = Follow.create(followed_id: u.id, follower_id: user.id)
          expect(follow).to be_valid
        end
      end

      context "when include_following is true" do
        subject { user.tweets_feed }

        it do
          expect(subject.size).to eq(30)
          previous_tweet_time = DateTime.current
          subject.each do |tweet|
            expect(tweet.created_at).to be <= previous_tweet_time
            previous_tweet_time = tweet.created_at
            expect(tweet.user.username).to be_present
          end
        end
      end

      context "when include_following is false" do
        subject { user.tweets_feed include_following: false }

        it do
          expect(subject.size).to eq(5)
          previous_tweet_time = DateTime.current
          subject.each do |tweet|
            expect(tweet.created_at).to be <= previous_tweet_time
            previous_tweet_time = tweet.created_at
            expect(tweet.user.username).to be_present
          end
          expect(subject).to match_array(user.tweets)
        end
      end
    end
  end
end
