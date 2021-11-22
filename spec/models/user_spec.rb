require 'rails_helper'

RSpec.describe User, type: :model do
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
end
