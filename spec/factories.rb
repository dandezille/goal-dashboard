FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :measurement, 70
  
  sequence :past_date do |n|
    n.days.ago.strftime('%Y-%m-%d')
  end

  sequence :future_date do |n|
    n.days.since.strftime('%Y-%m-%d')
  end

  factory :user do
    email
    password { 'super_secret' }

    trait :with_goal do
      association :goal
    end
  end

  factory :measurement do
    goal 
    date { generate(:past_date) }
    value { generate(:measurement) }
  end

  factory :goal do
    user
    date { generate(:future_date) }
    value { generate(:measurement) }
    
    trait :with_measurements do
      transient do
        measurements_count { 5 }
      end

      after :create do |goal, evaluator|
        create_list(:measurement, evaluator.measurements_count, goal: goal)
      end
    end
  end
end