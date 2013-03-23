require 'spec_helper'

describe Attendence do
  
  it "has a valid factory" do
    expect(build(:attendence)).to be_valid
  end

  it { should belong_to :member }

  it { should belong_to :event }

  it { should validate_presence_of :state }

  it "should allow only specific state values" do
    Attendence::STATES.keys.each do |key|
      should allow_value(key).for(:state)
    end
    should_not allow_value(5).for(:state)
  end

  it "should have pending state when first created" do
    expect(build(:attendence).state).to eq(Attendence::PENDING_STATE)
  end

  it "accepts" do
    a = build(:attendence)
    a.accept
    expect(a.state).to eq(Attendence::ACCEPTED_STATE)
  end

  it "rejects" do
    a = build(:attendence)
    a.reject
    expect(a.state).to eq(Attendence::REJECTED_STATE)
  end

end