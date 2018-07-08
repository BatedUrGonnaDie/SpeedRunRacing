FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

FactoryBot.define do
  factory :user do
    email
    username 'bated'
    password '1234567890'
    password_confirmation '1234567890'
  end

  trait :linked_account do
    twitch_id 1
  end
end
