require 'rails_helper'

RSpec.describe "venue_records/show", type: :view do
  before(:each) do
    user = User.create!(email: "user@example.com", password: "password123", password_confirmation: "password123")
    venue = Venue.create!(name: "LT1", building: "LSB", latitude: "22.41901", longitude: "114.20688")
    assign(:venue_record, VenueRecord.create!(user: user, venue: venue, date: Date.today, time: "10:00", is_absence: nil))
  end

  it "renders attributes in <p>" do
    render
  end
end
