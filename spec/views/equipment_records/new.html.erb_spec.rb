require 'rails_helper'

RSpec.describe "equipment_records/new", type: :view do
  before(:each) do
    assign(:equipment_record, EquipmentRecord.new())
  end

  it "renders new equipment_record form" do
    render

    assert_select "form[action=?][method=?]", equipment_records_path, "post" do
    end
  end
end
