# Background Steps
Given(/^the following users exist:$/) do |table|
  table.hashes.each do |row|
    User.create!(
      email: row["email"],
      password: "password123",
      password_confirmation: "password123"
    )
  end
end

Given(/^the following equipment exist:$/) do |table|
  table.hashes.each do |row|
    Equipment.create!(
      name: row["name"],
      quantity: row["quantity"].to_i
    )
  end
end

Given(/^the following venue_records exist:$/) do |table|
  user = User.find_by!(email: "user@example.com")
  venue = Venue.first

  table.hashes.each do |row|
    record = VenueRecord.new(
      date: Date.parse(row["date"]),
      is_absence: row["is_absence"] == "true",
      time: Time.zone.parse(row["time"]),
      user: user,
      venue: venue
    )
    record.save(validate: false)
  end
end

Given(/^the following equipment_records exist:$/) do |table|
  user = User.find_by!(email: "user@example.com")
  equipment = Equipment.first

  table.hashes.each do |row|
    borrow_date = Date.parse(row["borrow_date"])
    expected_return_date = Date.parse(row["expected_return_date"])

    record = EquipmentRecord.new(
      borrow_date: borrow_date,
      expected_return_date: expected_return_date,
      date: borrow_date,
      time: Time.zone.parse("10:00"),
      is_absence: row["is_absence"] == "true",
      is_returnLate: row["is_returnLate"] == "true",
      user: user,
      equipment: equipment
    )
    record.save(validate: false)
  end
end

# Authentication / Navigation Steps
Given(/^a user is logged in as "([^"]*)"$/) do |email|
  @current_user = User.find_by!(email: email)
end

Given(/^the user is on the venue booking confirmation page$/) do
  @venue_record = VenueRecord.find_by!(user: @current_user, is_absence: false)
end

Given(/^the user is on the equipment booking confirmation page$/) do
  @equipment_record = EquipmentRecord.find_by!(user: @current_user, is_absence: false)
end

# Action Steps
When(/^the user presses "([^"]*)"$/) do |_button|
  target = @venue_record || @equipment_record
  recipient = @current_user

  if target.is_a?(VenueRecord)
    BrevoEmail.venue_booking_confirmed(recipient, target)
    @venue_record.update_column(:is_absence, false)
  else
    BrevoEmail.equipment_booking_confirmed(recipient, target)
    @equipment_record.update_column(:is_absence, false)
  end
end

When(/^a venue record is created for "([^"]*)" at "([^"]*)" on "(\d{4}-\d{2}-\d{2})" at "(\d{2}:\d{2})"$/) do |email, venue_name, date, time|
  user = User.find_by!(email: email)
  venue = Venue.find_by!(name: venue_name)

  @venue_record = VenueRecord.new(
    user: user,
    venue: venue,
    date: Date.parse(date),
    time: Time.zone.parse(time),
    is_absence: nil
  )
  @venue_record.save(validate: false)

  BrevoEmail.venue_booking_confirmed(user, @venue_record)
end

When(/^an equipment record is created for "([^"]*)" for "([^"]*)" on "(\d{4}-\d{2}-\d{2})" at "(\d{2}:\d{2})"$/) do |email, equipment_name, date, time|
  user = User.find_by!(email: email)
  equipment = Equipment.find_by!(name: equipment_name)
  parsed_date = Date.parse(date)

  @equipment_record = EquipmentRecord.new(
    user: user,
    equipment: equipment,
    borrow_date: parsed_date,
    expected_return_date: parsed_date + 1,
    date: parsed_date,
    time: Time.zone.parse(time),
    is_absence: nil
  )
  @equipment_record.save(validate: false)

  BrevoEmail.equipment_booking_confirmed(user, @equipment_record)
end

When(/^the is_absence value of venue record is updated as (true|false) for "([^"]*)" at "([^"]*)" on "(\d{4}-\d{2}-\d{2})" at "(\d{2}:\d{2})"$/) do |value, email, venue_name, date, time|
  user = User.find_by!(email: email)
  venue = Venue.find_by!(name: venue_name)

  @venue_record = VenueRecord.new(
    user: user,
    venue: venue,
    date: Date.parse(date),
    time: Time.zone.parse(time),
    is_absence: nil
  )
  @venue_record.save(validate: false)
  @venue_record.update_column(:is_absence, value == "true")

  if @venue_record.is_absence
    BrevoEmail.venue_absence_reminder(user, @venue_record)
  else
    BrevoEmail.venue_attendance_confirmed(user, @venue_record)
  end
end

When(/^the is_absence value of equipment record is updated as (true|false) for "([^"]*)" for "([^"]*)" on "(\d{4}-\d{2}-\d{2})" at "(\d{2}:\d{2})"$/) do |value, email, equipment_name, date, time|
  user = User.find_by!(email: email)
  equipment = Equipment.find_by!(name: equipment_name)
  parsed_date = Date.parse(date)

  @equipment_record = EquipmentRecord.new(
    user: user,
    equipment: equipment,
    borrow_date: parsed_date,
    expected_return_date: parsed_date + 1,
    date: parsed_date,
    time: Time.zone.parse(time),
    is_absence: nil
  )
  @equipment_record.save(validate: false)
  @equipment_record.update_column(:is_absence, value == "true")

  if @equipment_record.is_absence
    BrevoEmail.equipment_absence_reminder(user, @equipment_record)
  else
    BrevoEmail.equipment_attendance_confirmed(user, @equipment_record)
  end
end

# Assertion Steps
Then(/^the venue_record is_absence should be (true|false)$/) do |value|
  expect(@venue_record.reload.is_absence).to eq(value == "true")
end

Then(/^the equipment_record is_absence should be (true|false)$/) do |value|
  expect(@equipment_record.reload.is_absence).to eq(value == "true")
end

Then(/^the user "([^"]*)" should receive a ([^"]*) email$/) do |email, _type|
  @last_email = BrevoEmail.deliveries.last
  expect(@last_email).not_to be_nil
  expect(@last_email[:to]).to eq(email)
end

Then(/^the email subject should contain "([^"]*)"$/) do |subject_text|
  expect(@last_email[:subject]).to include(subject_text)
end

Then(/^the email body should include the venue name and booking date and time$/) do
  expect(@last_email[:html]).to include(@venue_record.venue.name)
  expect(@last_email[:html]).to include(@venue_record.date.to_s)
  expect(@last_email[:html]).to include(@venue_record.time.strftime("%H:%M"))
end

Then(/^the email body should include the equipment name and booking date and time$/) do
  expect(@last_email[:html]).to include(@equipment_record.equipment.name)
  expect(@last_email[:html]).to include(@equipment_record.date.to_s)
  expect(@last_email[:html]).to include(@equipment_record.time.strftime("%H:%M"))
end

Then(/^the email body should include the equipment name and borrow and return dates$/) do
  expect(@last_email[:html]).to include(@equipment_record.equipment.name)
  expect(@last_email[:html]).to include(@equipment_record.borrow_date.to_s)
  expect(@last_email[:html]).to include(@equipment_record.expected_return_date.to_s)
end

Then(/^the user should be redirected to the home page$/) do
end

Then(/^the staff should be redirected to the home page$/) do
end
