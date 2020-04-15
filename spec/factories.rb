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
    
    trait :with_measurements do
      transient do
        measurements_count { 5 }
      end

      after :create do |user, evaluator|
        create_list(:measurement, evaluator.measurements_count, user: user)
      end
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