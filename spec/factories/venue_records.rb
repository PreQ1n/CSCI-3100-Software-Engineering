FactoryBot.define do
  factory :venue_record do
    association :user
    association :venue
    date { Date.current }
    time { Time.current }
    is_absence { nil }

    trait :expired_date do
      after(:build) { |record| record.save(validate: false) }
      date { Date.yesterday }
    end
    
    trait :expired_time do
      after(:build) { |record| record.save(validate: false) }
      time { 2.hours.ago }
    end
    
    trait :confirmed do
      is_absence { false }
    end
    
  end
end