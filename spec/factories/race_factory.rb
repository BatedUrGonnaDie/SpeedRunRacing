FactoryBot.define do
  factory :race do
    category
    association :creator, factory: :user

    trait :started do
      start_time { Time.now.utc }
      status_text { Race::PROGRESS }
    end

    trait :completed do
      start_time  { Time.now.utc - 2.hours }
      finish_time { Time.now.utc }
      status_text { Race::ENDED }
    end

    trait :with_entrants do
      after(:create) do |race, _evaluator|
        if race.finished?
          create_list(:entrant, 5, completed: true, race: race)
        elsif race.started?
          create_list(:entrant, 3, completed: true, race: race)
          create_list(:entrant, 2, race: race)
        else
          create_list(:entrant, 5, race: race)
        end
      end
    end
  end
end
