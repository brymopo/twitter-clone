require "rails_helper"

RSpec.describe StaticPagesController, type: :request do
  describe "GET /" do
    let(:user) { create(:user) }

    subject { get root_path }

    it "when user is not logged in" do
      is_expected.to redirect_to(new_user_session_path)
    end

    context "when user is logged in" do
      before do
        sign_in user
        subject
      end

      it { is_expected.to redirect_to user_path user }
    end
  end
end
