require 'rails_helper'

RSpec.describe "equipment_records/edit", type: :view do
  let(:equipment_record) {
    EquipmentRecord.create!()
  }

  before(:each) do
    assign(:equipment_record, equipment_record)
  end

  it "renders the edit equipment_record form" do
    render

    assert_select "form[action=?][method=?]", equipment_record_path(equipment_record), "post" do
    end
  end
end
