require 'spec_helper'

describe Member do

  it "has valid factory" do
    expect(build(:member)).to be_valid
  end

  it { should belong_to :department } 

  it { should have_many :shortlogs }

  it { should have_many :attendences }

  it { should have_many :notifications }

  it { should validate_numericality_of(:admission_year).only_integer }
  it { should allow_value(2012).for(:admission_year) }
  it { should allow_value(9999).for(:admission_year) }
  it { should_not allow_value(2010).for(:admission_year) }
  it { should_not allow_value(10000).for(:admission_year) }

  it { should allow_value(nil).for(:birthday) }

  it { should validate_numericality_of(:class_number).only_integer }
  it { should allow_value(1).for(:class_number) }
  it { should allow_value(20).for(:class_number) }
  it { should_not allow_value(0).for(:class_number) }
  it { should_not allow_value(21).for(:class_number) }

  it { should validate_presence_of :code_number }
  it { should allow_value(2011420).for(:code_number) }
  it { should_not allow_value(201120).for(:code_number) }
  it { should_not allow_value(20112000).for(:code_number) }

  it "should have matching admission year and code number" do
    expect(build(:member, admission_year:2011, code_number: 2012420)).to_not be_valid
  end

  it { should validate_presence_of :department }

  it { should allow_value("").for(:memo) }
  it { should ensure_length_of(:memo).is_at_most(2000) }

  it "should allow only specific genders" do
    Member::GENDERS.keys.each do |gender|
      should allow_value(gender).for(:gender)
    end
    should_not allow_value(27).for(:gender)
  end

  it { should allow_value("a.b@c.com").for(:email) }
  it { should_not allow_value("a.b@c").for(:email) }
  it { should ensure_length_of(:email).is_at_least(5).is_at_most(50) }
  it { should allow_value("").for(:email) }

  it { should validate_presence_of :name }
  it { should ensure_length_of(:name).is_at_least(2).is_at_most(10) }

  it { should validate_numericality_of(:phone_number).only_integer }
  it { should allow_value(12345678901).for(:phone_number) }
  it { should allow_value(12345678).for(:phone_number) }
  it { should_not allow_value(1234567).for(:phone_number) }
  it { should_not allow_value(123456789012).for(:phone_number) }
  it { should allow_value(nil).for(:phone_number) }

  it { should validate_numericality_of(:qq).only_integer }
  it { should allow_value(12345).for(:qq) }
  it { should allow_value(123451234512345).for(:qq) }
  it { should_not allow_value(1234).for(:qq) }
  it { should_not allow_value(1234512345123451).for(:qq) }
  it { should allow_value(nil).for(:qq) }

  it { should allow_value("").for(:secondary_school) }
  it { should ensure_length_of(:secondary_school).is_at_least(2).is_at_most(100) }

  it "should allow only specific privileges" do
    Member::PRIVILEGES.keys.each do |p|
      should allow_value(p).for(:privilege)
    end
    should_not allow_value(27).for(:privilege)
  end

  it { should ensure_length_of(:password).is_at_least(6).is_at_most(30) }

  it "should ensure password confirmation match" do
    expect(build(:member, password: "123456", password_confirmation: "1234567")).to_not be_valid
  end

  it "should generate password_digest" do
    m = build(:member)
    m.save
    expect(m.password_digest).to_not eq("")
  end

  it "should create new remember token every time it saves" do
    m = build(:member)
    expect { m.save }.to change{ m.remember_token }
  end

  it "should generate 1 shortlog if privilege is modified" do
    m = create(:member)
    m.privilege = Member::ADMINISTRATOR_PRIVILEGE
    expect { m.save }.to change { m.shortlogs.count }.by(1)
  end

  it "should generate 1 shortlog if department is modified" do
    m = create(:member)
    m.department = create(:department)
    expect { m.save }.to change { m.shortlogs.count }.by(1)
  end

  it "should not generate shortlogs if neither privilege nor department is modified" do
    m = create(:member)
    m.name = "Another"
    expect { m.save }.to_not change { m.shortlogs.count }
  end

end