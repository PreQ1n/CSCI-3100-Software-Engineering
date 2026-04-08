require 'rails_helper'

RSpec.describe "equipment_records/index", type: :view do
  before(:each) do
    assign(:equipment_records, [
      EquipmentRecord.create!(),
      EquipmentRecord.create!()
    ])
  end

  it "renders a list of equipment_records" do
    render
    cell_selector = 'div>p'
  end
end
