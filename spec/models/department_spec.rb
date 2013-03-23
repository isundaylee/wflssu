require 'spec_helper'

describe Department do

  it "is valid if all restrictions hold" do
    department = Department.new(name: 'IT Department', )
    expect(department).to be_valid
  end

  it { should validate_presence_of :name }

  it { should ensure_length_of(:name).is_at_most 50 }

  it { should have_many(:members) }

  it "returns the correct list of deparment names" do
    a = Department.create(name: 'IT')
    b = Department.create(name: 'Activities')
    expect(Department.names).to eq({a.id => a.name, b.id => b.name})
  end
end