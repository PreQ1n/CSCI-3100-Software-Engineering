require 'rspec/expectations' # Fixes the 'expect' error

Given("the following venues exist:") do |table|
  table.hashes.each do |attributes|
    Venue.create!(attributes)
  end
end

Given("I am on the venues page") do
  visit venues_path
end

When("I select {string} from the search column") do |option_text|
    # This bypasses the UI and forces the hidden HTML select to change
    select option_text, from: 'search_column', visible: false
end

When("I fill in {string} with {string}") do |field_name, value|
  fill_in field_name, with: value
end

When("I press {string}") do |button_text|
  click_button button_text
end

When("I follow {string}") do |link_text|
  click_link link_text
end

Then("I should see {string}") do |text|
  # Using 'page' explicitly helps ensure we are looking at the current session
  expect(page).to have_content(text)
end

Then("I should not see {string}") do |text|
  expect(page).not_to have_content(text)
end

