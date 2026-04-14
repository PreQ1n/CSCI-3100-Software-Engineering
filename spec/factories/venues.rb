FactoryBot.define do
  factory :venue do
    name { "Venue #{Faker::Number.unique.number}" }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end