require 'rails_helper'

RSpec.describe "Follows", type: :request do
  let(:user) { create(:user) }

  describe "GET /new" do
    subject { get new_user_follow_path(user) }

    it "when user is not logged in" do
      is_expected.to redirect_to(new_user_session_path)
    end

    context "when user is logged in" do
      before do
        sign_in user
        subject
      end

      it { is_expected.to render_template(:new) }
      it { expect(assigns(:follow)).to be_present }
    end
  end

  describe "POST /create" do
    let(:user2) { create(:user) }
    let(:params) { { follow: { username: user2.username } } }

    subject { post user_follows_path user, params: params }

    it "when user is not logged in" do
      is_expected.to redirect_to(new_user_session_path)
    end

    context "when user is logged in" do
      before do
        sign_in user
      end

      it "and not following requested user" do
        expect { subject }.to change(Follow, :count).by(1)
        is_expected.to redirect_to user_path(user2)
        expect(controller.flash[:notice]).to be_present
        expect(controller.flash[:alert]).to be_blank
      end

      it "and already following requested user" do
        new_follow = Follow.create(follower_id: user.id, followed_id: user2.id)
        expect(new_follow).to be_valid
        expect { subject }.not_to change(Follow, :count)
        is_expected.to render_template(:new)
        expect(controller.flash[:alert]).to be_present
        expect(controller.flash[:notice]).to be_blank
      end

      context "and username to follow does not exist" do
        let(:params) { { follow: { username: "doesnotexist" } } }

        before { subject }

        it { expect { subject }.not_to change(Follow, :count) }
        it { is_expected.to render_template(:new) }
      end

      context "and follower and followed are the same" do
        let(:params) { { follow: { username: user.username } } }

        before { subject }

        it { expect { subject }.not_to change(Follow, :count) }
        it { is_expected.to render_template(:new) }
      end
    end
  end
end
