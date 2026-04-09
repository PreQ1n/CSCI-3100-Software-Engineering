Given("the following history venues exist:") do |table|
  table.hashes.each do |row|
    Venue.create!(id: row["id"].to_i, name: row["name"])
  end
end

Given("the following history equipment exist:") do |table|
  table.hashes.each do |row|
    Equipment.create!(
      id: row["id"].to_i,
      name: row["name"],
      quantity: row["quantity"].to_i
    )
  end
end

Given("the following history users exist:") do |table|
  table.hashes.each do |row|
    User.create!(
      id: row["id"].to_i,
      email: row["email"],
      faculty: row["faculty"],
      college: row["college"],
      major: row["major"],
      password: "password",
      password_confirmation: "password"
    )
  end
end

Given("the following history venue_records exist:") do |table|
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

Given("the following history equipment_records exist:") do |table|
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

Given("I am logged in as user {string}") do |email|
  user = User.find_by!(email: email)

  visit login_path
  fill_in "Email", with: user.email
  fill_in "Password", with: "password"
  click_button "Login"
end

Given("I am logged in as a user with no bookings") do
  user = User.create!(
    email: "nobookings@example.com",
    password: "password",
    password_confirmation: "password",
    faculty: "Test",
    college: "Test",
    major: "Test"
  )

  visit login_path
  fill_in "Email", with: user.email
  fill_in "Password", with: "password"
  click_button "Login"
end

When("I visit the history page") do
  visit history_path
end

When("I click the history button {string}") do |button_text|
  click_button(button_text)
end

Then("I should see the {string} button") do |button_text|
  expect(page).to have_button(button_text)
end

Then("I should see a table with venue records") do
  expect(page).to have_css("table")
end

Then("I should see a table with equipment records") do
  expect(page).to have_css("table")
end

Then("the table should have columns {string}, {string}, {string}, {string}") do |col1, col2, col3, col4|
  [col1, col2, col3, col4].each do |col|
    expect(page).to have_css('th', text: col)
  end
end

Then("the table should have columns {string}, {string}, {string}, {string}, {string}") do |col1, col2, col3, col4, col5|
  [col1, col2, col3, col4, col5].each do |col|
    expect(page).to have_css('th', text: col)
  end
end

Then("I should see {string} in the venue table") do |text|
  within('table') do
    expect(page).to have_content(text)
  end
end

Then("I should see {string} in the equipment table") do |text|
  within('table') do
    expect(page).to have_content(text)
  end
end

Then("the venue record for {string} should show {string} as {string}") do |name, field, value|
  within('table tr', text: name) do
    expect(page).to have_content(value)
  end
end

Then("the equipment record for {string} should show {string} as {string}") do |name, field, value|
  within('table tr', text: name) do
    expect(page).to have_content(value)
  end
end

Then("I should see the history message {string}") do |text|
  expect(page).to have_content(text)
end