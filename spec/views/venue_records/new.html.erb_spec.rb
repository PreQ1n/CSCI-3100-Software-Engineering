require 'rails_helper'

RSpec.describe "venue_records/new", type: :view do
  let(:venue) { Venue.create!(name: "LT1", building: "LSB", latitude: "22.41901", longitude: "114.20688") }
  before(:each) do
    assign(:venue_record, VenueRecord.new(venue: venue))
  end

  it "renders new venue_record form" do
    render

    assert_select "form[action=?][method=?]", venue_records_path, "post" do
    end
  end
end
