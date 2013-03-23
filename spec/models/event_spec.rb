require 'spec_helper'

describe Event do

  it "has a valid factory" do
    expect(build(:event)).to be_valid
  end

  it { should have_many :attendences }

  it { should validate_presence_of :title }
  it { should ensure_length_of(:title).is_at_least(2) }
  it { should ensure_length_of(:title).is_at_most(20) }

  it { should validate_presence_of :on_date }

  it "should allow blank value for memo" do
    should allow_value("").for(:memo)
  end

end