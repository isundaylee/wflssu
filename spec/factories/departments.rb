require 'faker'

FactoryGirl.define do
  
  factory :department do
    name Faker::Company.name
  end

end