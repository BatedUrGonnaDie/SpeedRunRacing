FactoryBot.define do
  factory :entrant do
    transient do
      start_race false
      completed false
    end

    association :race
    association :user, :linked_account

    after(:create) do |entrant, evaluator|
      entrant.race.start if evaluator.start_race

      next unless evaluator.completed
      entrant.place = entrant.race.finished_entrants + 1
      entrant.finish_time = entrant.race.start_time + 1.minutes
    end
  end
end
