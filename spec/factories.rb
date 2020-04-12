FactoryBot.define do
  factory :user do
    email { 'user@example.com' }
    password { 'super_secret' }
  end

  factory :measurement do
    date { '2020-04-10' }
    value { 78.2 }
  end
end