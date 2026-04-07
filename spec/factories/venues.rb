FactoryBot.define do
  factory :venue do
    name { "Venue #{Faker::Number.unique.number}" }
  end
end