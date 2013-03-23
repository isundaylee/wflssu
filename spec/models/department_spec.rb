require 'spec_helper'

describe Department do

  it "has a valid factory" do
    expect(build(:department)).to be_valid
  end

  it { should validate_presence_of :name }

  it { should ensure_length_of(:name).is_at_most 50 }

  it { should have_many(:members) }

  it "returns the correct list of deparment names" do
    a = create(:department)
    b = create(:department)
    expect(Department.names).to eq({a.id => a.name, b.id => b.name})
  end
end