require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe "GET /show" do
    let(:user) { create(:user) }

    subject { get user_path(user) }

    context "when user is not logged in" do
      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context "when user is logged in" do
      before do
        sign_in user
        subject
      end

      it { expect(response.status).to be(200) }
      it { is_expected.to render_template(:show) }
      it { expect(assigns(:followers)).not_to be_nil }
      it { expect(assigns(:following)).not_to be_nil }
      it { expect(assigns(:tweets_feed)).not_to be_nil }
      it { expect(assigns(:usernames_followed)).not_to be_nil }
    end
  end

  describe "GET /followers" do
    let(:followers) { create_list(:user, 15) }
    let(:user) { create(:user) }

    subject { get followers_user_path(followed_user) }

    before do
      expect(user).to be_valid
      expect(followed_user).to be_valid

      sign_in user

      followers.each do |follower|
        expect(follower).to be_valid
        follow = Follow.create(follower_id: follower.id, followed_id: followed_user.id)
        expect(follow).to be_valid
      end
      subject
    end

    context "when user views their own info" do
      let(:followed_user) { user }

      it do
        is_expected.to render_template(:followers)
        expect(assigns(:followers).size).to eq(10)
        expected_array = user.reload.followers.alphabetical.first(10)
        expect(assigns(:followers)).to eq(expected_array)
        expect(assigns(:usernames_followed)).not_to be_nil
      end
    end

    context "when user views their own info, another page" do
      let(:followed_user) { user }

      subject { get followers_user_path(followed_user, page: 2) }

      it do
        is_expected.to render_template(:followers)
        expect(assigns(:followers).size).to eq(5)
        expected_array = user.reload.followers.alphabetical.last(5)
        expect(assigns(:followers)).to eq(expected_array)
        expect(assigns(:usernames_followed)).not_to be_nil
      end
    end

    context "when user views another user's info" do
      let(:followed_user) { create(:user) }

      it do
        is_expected.to render_template(:followers)
        response_followers = assigns(:followers)
        expect(user.reload.followers.alphabetical.first(10)).not_to eq(response_followers)
        expect(followed_user.reload.followers.alphabetical.first(10)).to eq(response_followers)
        expect(assigns(:usernames_followed)).not_to be_nil
      end
    end
  end

  describe "GET /following" do
    let(:followees) { create_list(:user, 15) }
    let(:user) { create(:user) }

    subject { get following_user_path(user_follower) }

    before do
      expect(user).to be_valid
      expect(user_follower).to be_valid

      sign_in user

      followees.each do |followee|
        expect(followee).to be_valid
        follow = Follow.create(follower_id: user_follower.id, followed_id: followee.id)
        expect(follow).to be_valid
      end
      subject
    end

    context "when user views their own info" do
      let(:user_follower) { user }

      it do
        is_expected.to render_template(:following)
        expect(assigns(:following).size).to eq(10)
        expected_array = user.reload.following.alphabetical.first(10)
        expect(assigns(:following)).to eq(expected_array)
        expect(assigns(:usernames_followed)).not_to be_nil
      end
    end

    context "when user views their own info, another page" do
      let(:user_follower) { user }

      subject { get following_user_path(user_follower, page: 2) }

      it do
        is_expected.to render_template(:following)
        expect(assigns(:following).size).to eq(5)
        expected_array = user.reload.following.alphabetical.last(5)
        expect(assigns(:following)).to eq(expected_array)
        expect(assigns(:usernames_followed)).not_to be_nil
      end
    end

    context "when user views another user's info" do
      let(:user_follower) { create(:user) }

      it do
        is_expected.to render_template(:following)
        response_followers = assigns(:following)
        expect(user.reload.following.alphabetical.first(10)).not_to eq(response_followers)
        expect(user_follower.reload.following.alphabetical.first(10)).to eq(response_followers)
        expect(assigns(:usernames_followed)).not_to be_nil
      end
    end
  end
end
