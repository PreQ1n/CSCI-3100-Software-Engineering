FactoryBot.define do
  factory :equipment_record do
    association :user
    association :equipment
    date { Date.current }
    time { Time.current }
    is_absence { nil }
  end
end