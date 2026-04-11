require 'rails_helper'

RSpec.describe "venue_records/index", type: :view do
  before(:each) do
    assign(:venue_records, [
      VenueRecord.create!(),
      VenueRecord.create!()
    ])
  end

  it "renders a list of venue_records" do
    render
    cell_selector = 'div>p'
  end
end
