require 'faker'

FactoryGirl.define do
  
  factory :notification do
    content "Just kidding"
    link "/"
    
    association :member
  end
  
end