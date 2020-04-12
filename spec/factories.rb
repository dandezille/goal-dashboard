FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password { 'super_secret' }
  end

  factory :measurement do
    date { '2020-04-10' }
    value { 78.2 }
  end
end