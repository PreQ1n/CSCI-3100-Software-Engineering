# Background Steps
# -----
Given(/^the following users exist:$/) do |table|
  table.hashes.each do |row|
    User.create!(
      email:                 row["email"],
      password:              "password123",
      password_confirmation: "password123"
    )
  end
end


Given(/^the following equipment exist:$/) do |table|
  table.hashes.each do |row|
    Equipment.create!(
      name:     row["name"],
      quantity: row["quantity"].to_i
    )
  end
end

Given(/^the following venue_records exist:$/) do |table|
  user  = User.find_by!(email: "user@example.com")
  venue = Venue.first
  table.hashes.each do |row|
    VenueRecord.create!(
      date:       Date.parse(row["date"]),
      is_absence: row["is_absence"] == "true",
      time:       row["time"],
      user:       user,
      venue:      venue
    )
  end
end

Given(/^the following equipment_records exist:$/) do |table|
  user      = User.find_by!(email: "user@example.com")
  equipment = Equipment.first
  table.hashes.each do |row|
    EquipmentRecord.create!(
      date:       Date.parse(row["date"]),
      is_absence: row["is_absence"] == "true",
      time:       row["time"],
      user:       user,
      equipment:  equipment
    )
  end
end

# Action Step
# -----
When (/^a venue record is created for "([^"]*)" at "([^"]*)" on "(\d{4}-\d{2}-\d{2})" at "(\d{2}:\d{2})"$/) do |email, venue_name, date, time|
  user  = User.find_by!(email: email)
  venue = Venue.find_by!(name: venue_name)
  @venue_record = VenueRecord.create!(
    user: user, venue: venue,
    date: Date.parse(date), time: Time.zone.parse(time),
    is_absence: nil
  )
  BrevoEmail.venue_booking_confirmed(user, @venue_record)
end

When (/^an equipment record is created for "([^"]*)" for "([^"]*)" on "(\d{4}-\d{2}-\d{2})" at "(\d{2}:\d{2})"$/) do |email, equipment_name, date, time|
  user      = User.find_by!(email: email)
  equipment = Equipment.find_by!(name: equipment_name)
  @equipment_record = EquipmentRecord.create!(
    user: user, equipment: equipment,
    date: Date.parse(date), time: Time.zone.parse(time),
    is_absence: nil
  )
  BrevoEmail.equipment_booking_confirmed(user, @equipment_record)
end

When(/^the is_absence value of venue record is updated as (true|false) for "([^"]*)" at "([^"]*)" on "(\d{4}-\d{2}-\d{2})" at "(\d{2}:\d{2})"$/) do |value, email, venue_name, date, time|
  user          = User.find_by!(email: email)
  venue         = Venue.find_by!(name: venue_name)
  @venue_record = VenueRecord.create!(
    user: user, venue: venue,
    date: Date.parse(date), time: Time.zone.parse(time),
    is_absence: nil)
  @venue_record.update!(is_absence: value == "true")
  if @venue_record.is_absence
    BrevoEmail.venue_absence_reminder(user, @venue_record)
  else
    BrevoEmail.venue_attendance_confirmed(user, @venue_record)
  end
end

When(/^the is_absence value of equipment record is updated as (true|false) for "([^"]*)" for "([^"]*)" on "(\d{4}-\d{2}-\d{2})" at "(\d{2}:\d{2})"$/) do |value, email, equipment_name, date, time|
  user              = User.find_by!(email: email)
  equipment         = Equipment.find_by!(name: equipment_name)
  @equipment_record = EquipmentRecord.create!(
    user: user, equipment: equipment,
    date: Date.parse(date), time: Time.zone.parse(time),
    is_absence: nil)
  @equipment_record.update!(is_absence: value == "true")
  if @equipment_record.is_absence
    BrevoEmail.equipment_absence_reminder(user, @equipment_record)
  else
    BrevoEmail.equipment_attendance_confirmed(user, @equipment_record)
  end
end

# Assertion Steps
Then (/^the user "([^"]*)" should receive a ([^"]*) email$/) do |email, type|
  @last_email = BrevoEmail.deliveries.last
  expect(@last_email).not_to be_nil
  expect(@last_email[:to]).to eq(email)
end

Then (/^the email subject should contain "([^"]*)"$/) do |subject_text|
  expect(@last_email[:subject]).to include(subject_text)
end

Then (/^the email body should include the venue name and booking date and time$/) do
  expect(@last_email[:html]).to include(@venue_record.venue.name)
  expect(@last_email[:html]).to include(@venue_record.date.to_s)
  expect(@last_email[:html]).to include(@venue_record.time.strftime("%H:%M"))
end

Then (/^the email body should include the equipment name and booking date and time$/) do
  expect(@last_email[:html]).to include(@equipment_record.equipment.name)
  expect(@last_email[:html]).to include(@equipment_record.date.to_s)
  expect(@last_email[:html]).to include(@equipment_record.time.strftime("%H:%M"))
end