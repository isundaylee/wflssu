require 'spec_helper'

describe Department do
  it "is valid if all restrictions hold" do
    department = Department.new(name: 'IT Department', )
    expect(department).to be_valid
  end

  it "is invalid without a name" do
    expect(Department.new(name: nil)).to have(1).errors_on(:name)
  end

  it "is invalid with a name more than 50 chars" do
    expect(Department.new(name: '*' * 51)).to have(1).errors_on(:name)
  end

  it "returns the correct lists of deparment names" do
    a = Department.create(name: 'IT')
    b = Department.create(name: 'Activities')
    expect(Department.names).to eq({a.id => a.name, b.id => b.name})
  end
end