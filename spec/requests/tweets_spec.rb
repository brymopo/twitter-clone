require 'rails_helper'

RSpec.describe TweetsController, type: :request do
  let(:user) { create(:user) }

  describe "GET #New" do
    subject { get new_user_tweet_path(user) }

    context "when user is not logged in" do
      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context "when user is logged in" do
      before do
        sign_in user
        subject
      end

      it { expect(response.status).to be(200) }
      it { expect(assigns(:tweet)).to be_present }
    end
  end

  describe "POST #Create" do
    let(:params) { { tweet: attributes_for(:tweet) } }

    subject { post user_tweets_path user, params: params }

    context "when user is not logged in" do
      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context "when user is logged in" do
      before { sign_in user }

      it "and form info is right" do
        expect { subject }.to change(Tweet, :count).by(1)
        expect(controller.flash[:notice]).to be_present
        expect(controller.flash[:alert]).to be_blank
        is_expected.to redirect_to(user_path(user))
      end

      context "and form is wrong" do
        let(:params) { { tweet: { message: "a" * 281 } } }

        before { subject }

        it { expect { subject }.not_to change(Tweet, :count) }
        it { expect(response.status).to be(200) }
        it { expect(controller.flash[:notice]).to be_blank }
        it { expect(controller.flash[:alert]).to be_present }
        it { is_expected.to render_template(:new) }
      end
    end
  end
end
