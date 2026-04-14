FactoryBot.define do
  factory :venue_record do
    association :user
    association :venue
    date { Date.current }
    time { Time.current }
    is_absence { nil }
  end
end