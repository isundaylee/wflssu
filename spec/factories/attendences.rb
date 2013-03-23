FactoryGirl.define do

  factory :attendence do
    association :event
    association :member
  end

end