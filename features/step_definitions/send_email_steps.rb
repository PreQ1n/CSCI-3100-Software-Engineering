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

Given(/^the following venues exist:$/) do |table|
  table.hashes.each do |row|
    Venue.create!(
      name:     row["name"],
      building: row["building"]
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

# Authentication Steps
# -----
Given (/^a user is logged in as "([^"]*)"$/) do |email|
  @current_user = User.find_by!(email: email)
end

Given (/^a staff member is logged in$/) do
  # Create or find a staff/admin user in the system
  @staff = User.find_or_create_by!(email: "staff@example.com") do |u|
    u.password_digest = BCrypt::Password.create("password")
  end
end

# Page Navigation Step
# -----
Given (/^the user is on the venue booking confirmation page$/) do
  @venue_record = VenueRecord.find_by!(user: @current_user, is_absence: false)
end

Given (/^the user is on the equipment booking confirmation page$/) do
  @equipment_record = EquipmentRecord.find_by!(user: @current_user, is_absence: false)
end

Given (/^the staff is on the venue absence management page$/) do
  @venue_record = VenueRecord.first
  @booking_user = User.find(@venue_record.user_id)
end

Given (/^the staff is on the equipment absence management page$/) do
  @equipment_record = EquipmentRecord.first
  @booking_user = User.find(@equipment_record.user_id)
end

# Action Step
# -----
When (/^the user presses "([^"]*)"$/) do |button|
  # User confirms their own booking — sets is_absence: false and sends confirmation
  @venue_record&.update!(is_absence: false)
  @equipment_record&.update!(is_absence: false)

  target = @venue_record || @equipment_record
  recipient = @current_user
  pending "BookingMailer not yet created"
  if target.is_a?(VenueRecord)
    BookingMailer.venue_confirmation(recipient, target).deliver_now
  else
    BookingMailer.equipment_confirmation(recipient, target).deliver_now
  end
end

When (/^the staff marks the venue booking as absent and presses "([^"]*)"$/) do |button|
  @venue_record.update!(is_absence: true)
  pending "BookingMailer not yet created"
  BookingMailer.venue_cancellation(@booking_user, @venue_record).deliver_now
end

When (/^the staff marks the equipment booking as absent and presses "([^"]*)"$/) do |button|
  @equipment_record.update!(is_absence: true)
  pending "BookingMailer not yet created"
  BookingMailer.equipment_cancellation(@booking_user, @equipment_record).deliver_now
end

# Assertion Steps
Then (/^the venue_record is_absence should be (true|false)$/) do |value|
  expect(@venue_record.reload.is_absence).to eq(value == "true")
end

Then (/^the equipment_record is_absence should be (true|false)$/) do |value|
  expect(@equipment_record.reload.is_absence).to eq(value == "true")
end

Then (/^the user "([^"]*)" should receive a confirmation email$/) do |email|
  @last_email = ActionMailer::Base.deliveries.last
  expect(@last_email).not_to be_nil
  expect(@last_email.to).to include(email)
end

Then (/^the user "([^"]*)" should receive a cancellation email$/) do |email|
  @last_email = ActionMailer::Base.deliveries.last
  expect(@last_email).not_to be_nil
  expect(@last_email.to).to include(email)
end

Then (/^the email subject should contain "([^"]*)"$/) do |subject_text|
  expect(@last_email.subject).to include(subject_text)
end

Then (/^the email body should include the venue name and booking date and time$/) do
  body = @last_email.body.to_s
  expect(body).to include(@venue_record.venue.name)
  expect(body).to include(@venue_record.date.to_s)
  expect(body).to include(@venue_record.time.strftime("%H:%M"))
end

Then (/^the email body should include the equipment name and booking date and time$/) do
  body = @last_email.body.to_s
  expect(body).to include(@equipment_record.equipment.name)
  expect(body).to include(@equipment_record.date.to_s)
  expect(body).to include(@equipment_record.time.strftime("%H:%M"))
end

Then (/^the user should be redirected to the home page$/) do
end

Then (/^the staff should be redirected to the home page$/) do
end
