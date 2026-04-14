require 'rails_helper'

RSpec.describe "venue_records/edit", type: :view do
  let(:user) { User.create!(email: "user@example.com", password: "password123", password_confirmation: "password123") }
  let(:venue) { Venue.create!(name: "LT1", building: "LSB", latitude: "22.41901", longitude: "114.20688") }
  let(:venue_record) { VenueRecord.create!(user: user, venue: venue, date: Date.today, time: "10:00", is_absence: nil) }

  before(:each) do
    assign(:venue_record, venue_record)
  end

  it "renders the edit venue_record form" do
    render

    assert_select "form[action=?][method=?]", venue_record_path(venue_record), "post" do
    end
  end
end
