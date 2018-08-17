FactoryBot.define do
  factory :race do
    category
    association :creator, factory: :user

    transient do
      with_entrants false
    end

    trait :started do
      start_time { Time.now.utc }
      status_text Race::PROGRESS
    end

    trait :completed do
      start_time  { Time.now.utc - 2.hours }
      finish_time { Time.now.utc }
      status_text Race::ENDED
    end

    after(:create) do |race, evaluator|
      if race.finished?
        create_list(:entrant, 5, completed: true, race: race) if evaluator.with_entrants
      else
        create_list(:entrant, 3, completed: true, race: race) if evaluator.with_entrants
        create_list(:entrant, 2, race: race) if evaluator.with_entrants
      end
    end
  end
end
