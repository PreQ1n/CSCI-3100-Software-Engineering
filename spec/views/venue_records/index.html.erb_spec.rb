require 'rails_helper'

RSpec.describe "venue_records/index", type: :view do
  let(:user) { User.create!(email: "user@example.com", password: "password123", password_confirmation: "password123") }
  let(:venue) { Venue.create!(name: "LT1", building: "LSB", latitude: "22.41901", longitude: "114.20688") }

  before(:each) do
    assign(:venue_records, [
      VenueRecord.create!(user: user, venue: venue, date: Date.today, time: "10:00", is_absence: nil),
      VenueRecord.create!(user: user, venue: venue, date: Date.today, time: "11:00", is_absence: nil)
    ])
  end

  it "renders a list of venue_records" do
    render
    expect(rendered).to include("10:00")
    expect(rendered).to include("11:00")
  end
end
