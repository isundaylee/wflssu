require 'spec_helper'

describe Shortlog do

  it "should have valid factory" do
    expect(build(:shortlog)).to be_valid
  end

  it { should belong_to :member }

  it { should validate_presence_of :member }

  it { should ensure_length_of(:content).is_at_least(2).is_at_most(200) }

end