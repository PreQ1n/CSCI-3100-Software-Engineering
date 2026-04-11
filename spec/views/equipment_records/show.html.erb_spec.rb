require 'rails_helper'

RSpec.describe "equipment_records/show", type: :view do
  before(:each) do
    assign(:equipment_record, EquipmentRecord.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
