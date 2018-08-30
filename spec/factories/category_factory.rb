FactoryBot.define do
  factory :category do
    game
    name { 'Any%' }
    weblink { 'https://www.speedrun.com/sms#Any%' }
    srdc_id

    trait :with_races do
      after(:create) do |category, _evaluator|
        create_list(:race, 5, category: category)
      end
    end
  end
end
