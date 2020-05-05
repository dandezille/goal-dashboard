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
      transient { measurements_count { 5 } }

      after(:stub) do |goal, eval|
        stub_list :measurement, eval.measurements_count, goal: goal
      end
      after(:build) do |goal, eval|
        build_list :measurement, eval.measurements_count, goal: goal
      end
      after(:create) do |goal, eval|
        create_list :measurement, eval.measurements_count, goal: goal
      end
    end
  end
end
