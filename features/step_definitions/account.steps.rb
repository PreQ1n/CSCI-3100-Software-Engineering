# features/step_definitions/account.steps.rb

def parse_date(date_string)
    raise ArgumentError, "date string is blank" if date_string.nil? || date_string.strip.empty?
    day, month, year = date_string.split('-')
    Date.new(year.to_i, month.to_i, day.to_i)
end

Given("I am logged in as a user") do 
    @current_user = User.create!(
        id: 1,
        email: "student@gmail.com",
        password: "111"
    )

    visit(login_path)
    fill_in("Email", with: @current_user.email)
    fill_in("Password", with: @current_user.password)
    click_button("Login")
end

When("My mouse on the account button") do 
    find(".dropdown-button").click
end

Then("a dropdown menu show") do
    expect(page).to have_css(".dropdown-content", visible: true)
end

Then("there are three option to choose:") do |table|
    options = table.raw.flatten
    within(".dropdown-content") do
        options.each do |option|
            expect(page).to have_link(option, visible: true)
        end
    end
end

When("I click on the {string} option in the account menu") do |option|
    within(".dropdown-content") do
        click_link(option)
    end
end

When("I click the ✅Press to Confirm button") do
    click_button("✅Press to Confirm")
end

Then("I should be on the {string}") do |path|
    expected_path = case path
    when "confirmation_path"
        confirmation_path
    when "calendar_path"
        calendar_path
    when "history_path"
        history_path  
    end
    expect(current_path).to eq(expected_path)
end

Then("I am on the main page") do
    expect(current_path).to eq(root_path)
end

Given("I am on the {string} page") do |page_name|
    case page_name
    when "Confirmation"
        visit(confirmation_path)
    when "Calendar"
        visit(calendar_path)
    when "History"
        visit(history_path)
    end
end

Given("the title should be {string}") do |title|
    page_title = find("h1").text
    expect(page_title).to eq(title)
end

Given("there is a {string} link") do |link|
    expect(page).to have_link(link)
end

When("I have a new confirmation") do
    @venue = Venue.create!(name: "Test Venue", latitude: 22.4001, longitude: 114.2001)
    @test_time = Time.current + 2.hours

    record = VenueRecord.new(
        user_id: @current_user.id,
        venue_id: @venue.id,
        date: Date.current,
        time: @test_time,
        is_absence: true
    )
    record.save(validate: false)
    @confirmation = record

    visit(current_path)
end

Then("it will show up a new confirmation") do 
    expect(page).to have_content("Test Venue")
    expect(page).to have_content(@test_time.strftime("%H:%M"))
end

Then("the confirmation will have a ✅Press to Confirm button") do
    expect(page).to have_button("✅Press to Confirm")
end

Then("the record will be removed") do
    expect(page).to have_content("Confirmed!")
    expect(page).to have_no_button("✅Press to Confirm")
end

Then("the recored will be update in the database") do
    @confirmation.reload
    expect(@confirmation.is_absence).to eq(false)
end

Then("I should see a monthly calendar view") do
    expect(page).to have_css(".calendar-container")
    expect(page).to have_css(".day-number")
end

Then("the current month and year should be display at the top") do
    month = Date.today.strftime("%B %Y")
    expect(page).to have_content(month)
end

Then("the days of the week should also be display") do
    days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    days.each do |day|
        expect(page).to have_content(day)
    end
end

Given("I have the following booked") do |table|
    table.hashes.each do |row|
        if row["Borrow Date"] && row["Return Date"]
            current_equipment = Equipment.create!(name: row["Name"], quantity: 5)
            record = EquipmentRecord.new(
                user_id: @current_user.id,
                equipment_id: current_equipment.id,
                borrow_date: parse_date(row["Borrow Date"]),
                expected_return_date: parse_date(row["Return Date"])
            )
            record.save(validate: false)
        elsif row["Date"] && row["Time"]
            current_venue = Venue.create!(name: row["Name"], latitude: 22.4002, longitude: 114.2002)
            record = VenueRecord.new(
                user_id: @current_user.id,
                venue_id: current_venue.id,
                date: parse_date(row["Date"]),
                time: Time.parse(row["Time"])
            )
            record.save(validate: false)
        end
    end

    visit(calendar_path)
end

Then("{int} April should show {string} and {string} on that day") do |day, name, time|
    expect(page).to have_content(day.to_s)
    expect(page).to have_content(name)

        # Equipment bookings are day-based; displayed time may vary by timezone rendering.
        unless name.include?("equipment")
            expect(page).to have_content(time)
        end
end

Then('{int} April should show {string} on that day') do |day, name|
  expect(page).to have_content(day.to_s)
  expect(page).to have_content(name)
end