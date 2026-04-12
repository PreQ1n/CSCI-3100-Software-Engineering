Given('the following users exists:') do |table|
    table.hashes.each do |row|
        User.create!(row)
    end
end

Given('the following venues exists:') do |table|
    table.hashes.each do |row|
        Venue.create!(
            id: row["venue_id"].to_i,  
            name: row["name"],
            building: row["building"],
            latitude: row["latitude"],
            longitude: row["longitude"]
        )
    end
end

Given('the following venue_records exists:') do |table|
    table.hashes.each do |row|
        record = VenueRecord.new(
            date: row["date"],
            is_absence: "true",
            time: row["time"],
            user: User.find_by!(id: row["user_id"]),
            venue: Venue.find_by!(id: row["venue_id"].to_i)  
        )
        record.save(validate: false)
    end
end

Then('I should see a map of {string} at {float}, {float}') do |venue_name, lat, long|
        venue = Venue.find_by!(name: venue_name)
        expect(page).to have_content(venue_name)
        expect(venue.latitude.to_f).to eq(lat)
        expect(venue.longitude.to_f).to eq(long)
end

Then(/^I should see a map of (.+) at (\d+\.\d+), (\d+\.\d+)$/) do |venue_name, lat, long|
    step 'I should see a map of "' + venue_name + '" at ' + lat + ', ' + long
end

When('I click {string}') do |button_name|
  click_button button_name
end

When('I fill in Name with {string}') do |name_value|
        if page.has_field?("venue_name")
            fill_in("venue_name", with: name_value)
        else
            fill_in("Name", with: name_value)
        end
end

When('I fill in Venue with {int}') do |venue_id_value|
        @selected_test_venue_id = venue_id_value
end

When('I press Create Venue') do
    click_button('Create Venue')
end

When('I press Back to venues') do
  click_link('Back to venues')
end
