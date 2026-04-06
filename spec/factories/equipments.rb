FactoryBot.define do
  factory :equipment do
    name { "Equipment #{Faker::Number.unique.number}" }
  end
end