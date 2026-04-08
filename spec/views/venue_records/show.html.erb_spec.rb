require 'rails_helper'

RSpec.describe "venue_records/show", type: :view do
  before(:each) do
    assign(:venue_record, VenueRecord.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
