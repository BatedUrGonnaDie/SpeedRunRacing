FactoryBot.define do
  factory :race do
    category

    trait :started do
      start_time { Time.now.utc }
      status_text Race::PROGRESS
    end
  end
end
