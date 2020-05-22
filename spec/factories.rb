FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :goal_title do |n|
    "Goal #{n}"
  end

  sequence :goal_units do |n|
    "Units#{n}"
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
      after(:stub) do |user, eval|
        stub_list :goal, 1, user: user
      end
      after(:build) do |user, eval|
        build_list :goal, 1, user: user
      end
      after(:create) do |user, eval|
        create_list :goal, 1, user: user
      end
    end
  end

  factory :measurement do
    goal
    date { generate(:past_date) }
    value { generate(:measurement) }
  end

  factory :goal do
    user
    title { generate(:goal_title) }
    units { generate(:goal_units) }
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
