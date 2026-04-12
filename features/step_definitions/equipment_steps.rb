require 'rspec/expectations'

Given("the following equipment exists:") do |table|
  table.hashes.each do |attributes|
    quantity = attributes["quantity"].present? ? attributes["quantity"].to_i : 1
    Equipment.create!(
      name: attributes["name"],
      description: attributes["description"],
      quantity: quantity
    )
  end
end

Given("I am on the equipment page") do
  visit equipment_index_path
end