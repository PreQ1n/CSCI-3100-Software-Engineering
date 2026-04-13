Given('a venue named {string} exists with lat: {float} and lng: {float}') do |string, float, float2|
  @venue = Venue.create!(name: string, latitude: float, longitude: float2)
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

Given('I am on the venue booking page of the venue') do
    visit new_venue_record_path(venue_id: @venue.venue_id)
end

Then('I should see a map available') do
    isMapPresent = page.execute_script("return window.map !== undefined && window.map !== null")
    expect(isMapPresent).to eq(true)
end

Then('the map is centered on the coordinates of the venue') do
    pageLat = page.execute_script("return window.map.getCenter().lat()").round(5)
    pageLng = page.execute_script("return window.map.getCenter().lng()").round(5)
    
    expect(pageLat).to eq(@venue.latitude.round(5))
    expect(pageLng).to eq(@venue.longitude.round(5))
end