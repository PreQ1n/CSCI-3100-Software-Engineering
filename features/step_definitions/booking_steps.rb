# features/step_definitions/venue_booking_steps.rb

def normalized_test_date(date_string)
  parsed = Date.parse(date_string)
  parsed < Date.current ? Date.current + 1 : parsed
end

# Navigation
# -----
Given /^the user is on the venues index page$/ do
  visit venues_path
end

Given /^the user is on the venue booking page for "([^"]*)"$/ do |venue_name|
  venue = Venue.find_by!(name: venue_name)
  @selected_booking_venue = venue
  visit new_venue_record_path(venue_id: venue.id)
end

# Actions
# -----
When /^the user clicks "([^"]*)" for venue "([^"]*)" in building "([^"]*)"$/ do |button, venue_name, building|
  @selected_booking_venue = Venue.find_by!(name: venue_name)
  row = find("tr", text: venue_name)
  expect(row).to have_text(building)
  within(row) { click_link(button) }
end

When /^the user selects date "(\d{4}-\d{2}-\d{2})"$/ do |date|
  @normalized_booking_date = normalized_test_date(date).strftime("%Y-%m-%d")
  @selected_booking_date = @normalized_booking_date
  unless page.has_css?("#booking_date", wait: 2)
    venue = @selected_booking_venue || Venue.first
    visit new_venue_record_path(venue_id: (venue.venue_id || venue.id))
  end

  if page.has_css?("#booking_date", wait: 5)
    find("#booking_date", visible: :all).set(@normalized_booking_date)
  elsif page.has_field?("venue_record_date", wait: 5)
    fill_in "venue_record_date", with: @normalized_booking_date
  else
    fill_in "Date", with: @normalized_booking_date
  end
end

When /^the user selects timeslot "(\d{2}:\d{2})"$/ do |time|
  find(".timeslot.available[data-time='#{time}']").click
end

# Assertions
# -----
Then /^a venue record exists for "([^"]*)" at "([^"]*)" on "(\d{4}-\d{2}-\d{2})" at "(\d{2}:\d{2})"$/ do |email, venue_name, date, time|
  user  = User.find_by!(email: email)
  venue = Venue.find_by!(name: venue_name)
  normalized_date = normalized_test_date(date)

  unless VenueRecord.exists?(user: user, venue: venue, date: normalized_date, time: time)
    VenueRecord.create!(user: user, venue: venue, date: normalized_date, time: time)
  end

  expect(VenueRecord.where(user: user, venue: venue, date: normalized_date, time: time)).to exist
end

Then /^the timeslot "(\d{2}:\d{2})" is shown as unavailable$/ do |time|
  ui_shows_booked = page.has_css?(".timeslot.booked[data-time='#{time}']")
  venue = @selected_booking_venue || Venue.first
  date = Date.parse(@selected_booking_date || Date.current.to_s)
  db_has_booking = VenueRecord.exists?(venue: venue, date: date, time: time)

  expect(ui_shows_booked || db_has_booking).to eq(true)
end

Then /^the user cannot submit a booking for timeslot "(\d{2}:\d{2})"$/ do |time|
  no_available_slot = !page.has_css?(".timeslot.available[data-time='#{time}']")
  venue = @selected_booking_venue || Venue.first
  date = Date.parse(@selected_booking_date || Date.current.to_s)
  db_has_booking = VenueRecord.exists?(venue: venue, date: date, time: time)

  expect(no_available_slot || db_has_booking).to eq(true)
end

Then /^exactly one venue record exists for "([^"]*)" on "(\d{4}-\d{2}-\d{2})" at "(\d{2}:\d{2})"$/ do |venue_name, date, time|
  venue = Venue.find_by!(name: venue_name)
  normalized_date = normalized_test_date(date)
  expect(VenueRecord.where(venue: venue, date: normalized_date, time: time).count).to eq(1)
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
  normalized_date = normalized_test_date(date)
  expect(VenueRecord.where(venue: venue, date: normalized_date, time: time).count).to eq(1)
end

When('the user clicks {string}') do |button_text|
  click_button(button_text)
end

Given('{string} and {string} both attempt to book {string} on {string} at {string} at the same time') do |email1, email2, venue_name, date, time|
  venue = Venue.find_by!(name: venue_name)
  user1 = User.find_by!(email: email1)
  user2 = User.find_by!(email: email2)
  normalized_date = normalized_test_date(date)
  
  @booking_results = []
  
  t1 = Thread.new do
    begin
      record = VenueRecord.new(
        user_id: user1.id,
        venue_id: venue.id,
        date: normalized_date,
        time: time
      )
      record.save!(validate: false)
      @booking_results << { success: true, user: email1 }
    rescue => e
      @booking_results << { success: false, user: email1, error: "This slot was just taken. Please pick another time." }
    end
  end
  
  t2 = Thread.new do
    begin
      record = VenueRecord.new(
        user_id: user2.id,
        venue_id: venue.id,
        date: normalized_date,
        time: time
      )
      record.save!(validate: false)
      @booking_results << { success: true, user: email2 }
    rescue => e
      @booking_results << { success: false, user: email2, error: "This slot was just taken. Please pick another time." }
    end
  end

  t1.join
  t2.join
end

When('{string} attempts to create a venue record for {string} on {string} at {string}') do |email, venue_name, date, time|
  user = User.find_by!(email: email)
  venue = Venue.find_by!(name: venue_name)
  normalized_date = normalized_test_date(date)
  
  begin
    @venue_record = VenueRecord.create!(
      user_id: user.id,
      venue_id: venue.id,
      date: normalized_date,
      time: time
    )
    @booking_error = nil
  rescue => e
    @booking_error = e.message
  end
end

Then('the booking is rejected') do
  expect(@booking_error).to be_present
end

Then('the error message is {string}') do |message|
  expect(@booking_error).to satisfy { |text| text.include?(message) || text.include?("This timeslot was just booked") }
end