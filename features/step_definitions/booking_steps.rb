# features/step_definitions/venue_booking_steps.rb

# Navigation
# -----
Given /^the user is on the venues index page$/ do
  visit venues_path
end

Given /^the user is on the venue booking page for "([^"]*)"$/ do |venue_name|
  venue = Venue.find_by!(name: venue_name)
  visit new_venue_record_path(venue_id: venue.id)
end

# Actions
# -----
When /^the user clicks "([^"]*)" for venue "([^"]*)" in building "([^"]*)"$/ do |button, venue_name, building|
  within(".venue-card", text: venue_name) do
    click_button button
  end
end

When /^the user selects date "(\d{4}-\d{2}-\d{2})"$/ do |date|
  fill_in "date", with: date
end

When /^the user selects timeslot "(\d{2}:\d{2})"$/ do |time|
  find(".timeslot.available[data-time='#{time}']").click
end

# Assertions
# -----
Then /^a venue record exists for "([^"]*)" at "([^"]*)" on "(\d{4}-\d{2}-\d{2})" at "(\d{2}:\d{2})"$/ do |email, venue_name, date, time|
  user  = User.find_by!(email: email)
  venue = Venue.find_by!(name: venue_name)
  expect(VenueRecord.where(user: user, venue: venue, date: date, time: time)).to exist
end

Then /^the timeslot "(\d{2}:\d{2})" is shown as unavailable$/ do |time|
  expect(page).to have_css(".timeslot.booked[data-time='#{time}']")
end

Then /^the user cannot submit a booking for timeslot "(\d{2}:\d{2})"$/ do |time|
  expect(page).not_to have_css(".timeslot.available[data-time='#{time}']")
end

Then /^exactly one venue record exists for "([^"]*)" on "(\d{4}-\d{2}-\d{2})" at "(\d{2}:\d{2})"$/ do |venue_name, date, time|
  venue = Venue.find_by!(name: venue_name)
  expect(VenueRecord.where(venue: venue, date: date, time: time).count).to eq(1)
end

Then /^one user receives a booking confirmation$/ do
  expect(@booking_results.count { |r| r[:success] }).to eq(1)
end

Then /^the other user receives an error "([^"]*)"$/ do |message|
  failed = @booking_results.find { |r| !r[:success] }
  expect(failed[:error]).to include(message)
end

Then /^only one venue record exists for "([^"]*)" on "(\d{4}-\d{2}-\d{2})" at "(\d{2}:\d{2})"$/ do |venue_name, date, time|
  venue = Venue.find_by!(name: venue_name)
  expect(VenueRecord.where(venue: venue, date: date, time: time).count).to eq(1)
end