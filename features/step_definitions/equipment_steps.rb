require 'rspec/expectations'

Given("the following equipment exists:") do |table|
    table.hashes.each do |attributes|
      CuhkEquipment.create!(attributes)
    end
  end
  
Given("I am on the equipment page") do
    visit cuhk_equipments_path
end
  