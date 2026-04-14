FactoryBot.define do
  factory :equipment do
    name { "Equipment #{Faker::Number.unique.number}" }
    quantity { Faker::Number.between(from: 1, to: 100) }
  end
end