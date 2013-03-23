require 'faker'

FactoryGirl.define do
  
  factory :member do
    admission_year 2011
    birthday "1997-04-20"
    class_number 8
    code_number 2011420
    email Faker::Internet.email
    gender Member::MALE_GENDER
    name 'Faker'
    phone_number 18607110799
    qq 123456789
    secondary_school "Non-existing school"
    password "2011420"
    password_confirmation "2011420"
    privilege Member::MEMBER_PRIVILEGE

    association :department
  end
  
end