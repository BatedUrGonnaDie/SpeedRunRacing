FactoryBot.define do
  sequence :srdc_id do |n|
    "#{n}hello"
  end
end

FactoryBot.define do
  factory :game do
    name { 'Super Mario Sunshine' }
    shortname { 'sms' }
    srdc_id
    weblink { 'https://www.speedrun.com/sms' }
    cover_large { 'https://www.speedrun.com/themes/sms/cover-256.png' }
    cover_small { 'https://www.speedrun.com/themes/sms/cover-32.png' }

    trait :with_categories do
      after(:create) do |game, _evaluator|
        create_list(:category, 5, game: game)
      end
    end

    trait :with_races do
      after(:create) do |game, _evaluator|
        create_list(:category, 5, :with_races, game: game)
      end
    end
  end
end
