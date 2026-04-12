Given('the following venues exists:') do |table|
    table.hashes.each do |venue|
        Venue.create!(venue)
    end
end

# This is here because js testing requires logging in
Given('I am logged in as {string} with password {string}') do |email, password|
  @current_user = User.create!(email: email, password: password)
  visit login_path
  fill_in("Email", with: email)
  fill_in("Password", with: password)
  click_button("Login")
  expect(page).to have_current_path(root_path)
end

Given('I am on the venue booking page of {string}') do |string|
    venue = Venue.find_by!(name: string)
    visit new_venue_record_path(venue_id: venue.venue_id)
end

Given('I am on the create new venues page') do
    visit new_venue_path
end

Then('I should see a map available') do
    expect(page).to have_css("#map", visible: true)
end

Then('the map is centered on the coordinates of {string}') do |string|
    venue = Venue.find_by!(name: string)
    
    expect(venue.latitude.round(5)).to eq(page.execute_script("return window.map.getCenter().lat()").round(5))
    expect(venue.longitude.round(5)).to eq(page.execute_script("return window.map.getCenter().lng()").round(5))
end

Then('the map is centered on the default coordinates') do
    expect(page.execute_script("return window.map.getCenter().lat()").round(5)).to eq(22.3565)
    expect(page.execute_script("return window.map.getCenter().lng()").round(5)).to eq(114.1363)
end

Then('I search for {string} in the name field') do |string|
    fill_in("search-input", with: string)
    sleep 2
    # find first dropdown
    find("#search-input").send_keys(:down)
    sleep 1
    find('.pac-item', match: :first).click
    sleep 1
end

Then('the map is centered on lat: {float} long: {float}') do |float, float2|
    expect(page.execute_script("return window.map.getCenter().lat()").round(5)).to eq(float.round(5))
    expect(page.execute_script("return window.map.getCenter().lng()").round(5)).to eq(float2.round(5))
end