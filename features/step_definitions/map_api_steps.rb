Given('the following users exists:') do |table|
    table.hashes.each do |row|
        User.create!(row)
    end
end

Given('the following venues exists:') do |table|
    table.hashes.each do |row|
        Venue.create!(
            name: row["name"],
            building: row["building"],
            latitude: row["latitude"],
            longitude: row["longitude"],
        )
    end
end

Given('the following venue_records exists:') do |table|
    table.hashes.each do |row|
        VenueRecord.create!(
            date: row["date"],
            is_absence: "true",
            time: row["time"],
            user: User.find_by!(id: row["user_id"]),
            venue: Venue.find_by!(venue_id: row["venue_id"])
        )
    end
end

Then('I should see a map of {string} at {float}, {float}') do |venue_name, lat, long|
    expect(page).to have_content(venue_name)
    expect(page.body).to include(lat.to_s)
    expect(page.body).to include(long.to_s)
end

When('I click {string}') do |button_name|
  click_button button_name
end

When('I fill in Name with {string}') do |name_value|
    fill_in("Name", :with => name_value)
end

When('I fill in Venue with {int}') do |venue_id_value|
    fill_in("Venue", :with => Venue.find_by!(id: venue_id_value))
end