FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :weight, 70
  
  sequence :date do |n|
    n.days.ago.strftime('%Y-%m-%d')
  end

  factory :user do
    email
    password { 'super_secret' }

    trait :with_goal do
      association :goal
    end
  end

  factory :measurement do
    user
    date 
    value { generate(:weight) }
  end

  factory :goal do
    user
    date 
    value { generate(:weight) }
  end
end