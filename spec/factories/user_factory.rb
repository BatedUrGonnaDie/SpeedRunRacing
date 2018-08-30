FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :username do |n|
    "bated#{n}"
  end
end

FactoryBot.define do
  factory :user do
    email
    username
    password { '1234567890' }
    password_confirmation { '1234567890' }

    trait :linked_account do
      twitch_id { 1 }
    end
  end
end
