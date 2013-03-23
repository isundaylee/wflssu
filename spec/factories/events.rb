require 'faker'

FactoryGirl.define do

  factory :event do
    title Faker::Lorem.word
    on_date Date.today
  end
  
end