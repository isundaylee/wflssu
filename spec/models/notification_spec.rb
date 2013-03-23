require 'spec_helper'

describe Notification do

  it "should have valid factory" do
    expect(build(:notification)).to be_valid
  end

  it { should belong_to :member }

  it { should validate_presence_of :member }

  it { should allow_value("").for(:content) }
  it { should ensure_length_of(:content).is_at_most(100) }

  it { should allow_value("").for(:link) }
  it { should ensure_length_of(:link).is_at_most(100) }

  it { should validate_presence_of :state }
  it "should allow only specific states" do
    Notification::STATES.keys.each do |s|
      should allow_value(s).for(:state)
    end
    should_not allow_value(27).for(:state)
  end

  it "should default state to unread for new record" do
    n = create(:notification)
    expect(n.state).to eq(Notification::UNREAD_STATE)
  end

end