require 'rails_helper'

RSpec.describe "venue_records/edit", type: :view do
  let(:venue_record) {
    VenueRecord.create!()
  }

  before(:each) do
    assign(:venue_record, venue_record)
  end

  it "renders the edit venue_record form" do
    render

    assert_select "form[action=?][method=?]", venue_record_path(venue_record), "post" do
    end
  end
end
