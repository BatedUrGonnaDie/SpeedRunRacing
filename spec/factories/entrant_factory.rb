FactoryBot.define do
  factory :entrant do
    transient do
      start_race false
    end
    association :race
    association :user, :linked_account

    after(:create) do |entrant, evaluator|
      entrant.race.start if evaluator.start_race
    end

    trait :finished do
      place 1
      finish_time { Time.now.utc }
    end
  end
end
