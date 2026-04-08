Given("the following venues exist:") do |table|
  table.hashes.each do |row|
    Venue.create!(id: row["id"].to_i, name: row["name"])
  end
end

Given("the following equipment exist:") do |table|
  table.hashes.each do |row|
    Equipment.create!(
      id: row["id"].to_i,
      name: row["name"],
      quantity: row["quantity"].to_i
    )
  end
end

Given("the following users exist:") do |table|
  table.hashes.each do |row|
    User.create!(
      id: row["id"].to_i,
      email: row["email"],
      faculty: row["faculty"],
      college: row["college"],
      major: row["major"],
      password: "password123",
      password_confirmation: "password123"
    )
  end
end

Given("the following venue_records exist:") do |table|
  table.hashes.each do |row|
    VenueRecord.create!(
      user_id: row["user_id"].to_i,
      venue_id: row["venue_id"].to_i,
      date: Date.parse(row["date"]),
      time: Time.parse(row["time"]),
      is_absence: row["is_absence"] == "true"
    )
  end
end

Given("the following equipment_records exist:") do |table|
  table.hashes.each do |row|
    EquipmentRecord.create!(
      user_id: row["user_id"].to_i,
      equipment_id: row["equipment_id"].to_i,
      date: Date.parse(row["date"]),
      time: Time.parse(row["time"]),
      is_absence: row["is_absence"] == "true",
      is_returnLate: row["is_returnLate"] == "true"
    )
  end
end

Given("I am logged in as an administrator") do
  @admin_user = User.create!(
    email: "admin@example.com",
    password: "password123",
    password_confirmation: "password123",
    admin: true,
    faculty: "Admin",
    college: "Admin",
    major: "Admin"
  )

  visit(login_path)
  fill_in("Email", with: @admin_user.email)
  fill_in("Password", with: "password123")
  click_button("Login")
end

When("I visit the analytics dashboard") do
  visit analytics_dashboard_path(start_date: "2026-03-01", end_date: "2026-03-05")
end

Then("I should see a breakdown of user booking frequency") do
  expect(page).to have_content("Booking Frequency Per User")
end

Then("I should see users categorized as {string} or {string}") do |label1, label2|
  expect(page).to have_content(label1)
  expect(page).to have_content(label2)
end

Then("the repeat users count should be at least {string}") do |value|
  count_text = find(".user-frequency").text
  repeat_count = count_text[/Repeat Users.*?(\d+)/m, 1].to_i
  expect(repeat_count).to be >= value.to_i
end

Then("I should see a list of venues with their utilization rates") do
  expect(page).to have_content("Resource Utilization Per Venue")
end

Then("{string} should have the highest utilization rate") do |venue_name|
  first_row = find(".venue-utilization tbody tr", match: :first)
  expect(first_row).to have_content(venue_name)
end

Then("each venue should display a utilization percentage") do
  all(".venue-utilization tbody tr").each do |row|
    expect(row.text).to match(/\d+(\.\d+)?%/)
  end
end

Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end

Then("the average bookings per day should be displayed as {string}") do |value|
  expect(page).to have_content(value)
end

Then("I should see a list of top venues by booking count") do
  expect(page).to have_content("Top Venues by Booking Count")
end

Then("{string} should be the top venue") do |venue_name|
  first_row = find(".top-venues tbody tr", match: :first)
  expect(first_row).to have_content(venue_name)
end

Then("I should see a list of top equipment by booking count") do
  expect(page).to have_content("Top Equipment by Booking Count")
end

Then("{string} should be the top equipment") do |equipment_name|
  first_row = find(".top-equipment tbody tr", match: :first)
  expect(first_row).to have_content(equipment_name)
end

Then("the Absence rate should be displayed as {string}") do |value|
  expect(page).to have_content(value)
end

Then("I should see a breakdown by faculty") do
  expect(page).to have_content("Faculty Booking Distribution")
end

Then("{string} should have the highest booking count") do |label|
  faculty_first_row = find(".faculty-distribution tbody tr:first-child")
  
  if faculty_first_row.has_content?(label)
    expect(faculty_first_row).to have_content(label)
  else
    college_first_row = find(".college-distribution tbody tr:first-child")
    expect(college_first_row).to have_content(label)
  end
end

Then("the booking count for {string} should be displayed as {string}") do |label, count|
  expect(page).to have_content(label)
  expect(page).to have_content(count)
end

Then("I should see a breakdown by college") do
  expect(page).to have_content("College Booking Distribution")
end

Then("I should see a list of top {int} majors by booking count") do |_count|
  expect(page).to have_content("Top 5 Majors by Booking Count")
end

Then("{string} should be the top major") do |major|
  first_row = find(".major-distribution tbody tr", match: :first)
  expect(first_row).to have_content(major)
end

Then("the booking count for {string} should be at least {string}") do |label, value|
  row = find(".major-distribution tbody tr", text: label)
  count_text = row.all("td")[-1].text  
  count = count_text.to_i
  expect(count).to be >= value.to_i
end

Then("the late return rate should be displayed as {string}") do |value|
  expect(page).to have_content(value)
end