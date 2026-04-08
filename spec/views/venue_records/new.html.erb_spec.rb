require 'rails_helper'

RSpec.describe "venue_records/new", type: :view do
  before(:each) do
    assign(:venue_record, VenueRecord.new())
  end

  it "renders new venue_record form" do
    render

    assert_select "form[action=?][method=?]", venue_records_path, "post" do
    end
  end
end
