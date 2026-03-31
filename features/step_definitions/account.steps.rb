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

When("My mouse on the {string} button") do |button|
    case button
    when "account"
    find("#account_button").hover
    end
end

Then("a dropdown menu (not )? show") do |no|
    if no
        expect(page).to have_no_selector('#account_dropdown', visible: true)
    else
        expect(page).to have_selector("#account_dropdown", visible: true)
    end
end

Then("there are three option to choose:") do |table|
    options = table.raw.flatten.map{|x| x.strip}
    
    menu_options = within("#account_menu") do 
        page.all("li").map(&:text).map(&:strip)
    end

    expect(options).to eq(menu_options)
end

When("I click on the {string} option in the account menu") do |option|
    within("#account_menu") do
        find("li", text:option).click
    end
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

When ("my mouse not on the button") do
    find("header").hover
end

Given("I am on the {string} page") do |path|
    case path
    when "confirmation_path"
        visit(confirmation_path)
    when "calendar_path"
        visit(calendar_path)
    when "history_path"
        visit(history_path)
    when "main"
        visit(root_path)
    end

end

Given("the title should be {string}") do |title|
    page_title = find("header").text

    expect(page_title).to eq(title)
end

Given("there is a {string} button") do |button|
    expect(page).to have_button(button)
end

When("I have a new confirmation") do

    @venue = Venue.create!(
        name: "Test Venue"
    )

    @confirmation = VenueRecord.create!(
        user_id: @current_user.id,
        venue_id: @venue.id,
        date: Date.new(2026,3,16),
        time: "13:00".to_time
    )

    visit(current_path)
end

Then("it will show up a new confirmation") do 
    expect(page).to have_selector('.confirmation-record', count: 1)
    expect(page).to have_content("Test Venue")
    expect(page).to have_content("2026-3-16")
    expect(page).to have_content("13:00")
end

Then("the confirmation will have a {string} button") do |button|
    within(".confirmation-record") do
        expect(page).to have_button(button)
    end
end

Then("the record will be removed") do
    expect(page).to have_selector('.confirmation-record', count: 0)
end

Then("the recored will be update in the database") do
    @confirmation.reload
    expect(@confirmation.is_absence).to eq(false)
end

Then("I should see a monthly calendar view") do
    expect(page).to have_selector(".calendar-view")
    expect(page).to have_selector(".calendar-grid")
end

Then("the current month and year should be display at the top") do
    month = Date.today.strftime("%B %Y")
    expect(page).to have_selector("#calendar-id", text: month)
end

Then("the days of the week should also be display") do
    days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    days.each do |day|
        expect(page).to have_selector(".calendar-day", text:day)
    end
end

Given("I have the the following booked") do |table|
    table.hashes.each do |row|
        if row["Name"].include?("venue")
            current_venue = create!(
                name: row["Name"]
            )

            VenueRecord.create!(
                user_id: @current_user.id,
                venue_id: current_venue.id,
                date: Date.parse(row["Date"]),
                time: Time.parse(row["Time"])
            )
        else
            current_equipment = create!(
                name: row["Name"]
            )

            EquipmentRecord.create!(
                user_id: @current_user.id,
                venue_id: current_equipment.id,
                date: Date.parse(row["Date"]),
                time: Time.parse(row["Time"])
            )
        end
    end
    
    visit(current_path)
end

Then("{int} March should show {string} and {string} on that day") do |day, name, time|

    date = Date.new(2026, 3, day)
    day_cell = find(".calendar-day[date='#{date}']")

    within(day_cell) do
        expect(page).to have_content(name)
        expect(page).to have_content(time)
    end
end










