require 'rspec/expectations'

Given("the following venues exist:") do |table|
  table.hashes.each_with_index do |attributes, index|
    Venue.create!(
      name: attributes["name"],
      building: attributes["building"],
      description: attributes["description"],
      latitude: attributes["latitude"] || (22.40 + index * 0.001),
      longitude: attributes["longitude"] || (114.20 + index * 0.001)
    )
  end
end

Given("I am on the venues page") do
  visit venues_path
end