FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end
  
  sequence :value, 70

  factory :user do
    email
    password { 'super_secret' }
  end

  factory :measurement do
    user
    date { '2020-04-10' }
    value 
  end
end