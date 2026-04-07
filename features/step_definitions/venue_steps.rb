require 'rspec/expectations'

Given("the following venues exist:") do |table|
  table.hashes.each do |attributes|
    Venue.create!(attributes)
  end
end

Given("I am on the venues page") do
  visit venues_path
end