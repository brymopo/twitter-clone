require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:message) }
    it { is_expected.to validate_length_of(:message).is_at_most(280) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end
end
