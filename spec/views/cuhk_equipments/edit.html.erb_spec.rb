require 'rails_helper'

RSpec.describe "cuhk_equipments/edit", type: :view do
  let(:cuhk_equipment) {
    CuhkEquipment.create!(
      name: "MyString",
      description: "MyText"
    )
  }

  before(:each) do
    assign(:cuhk_equipment, cuhk_equipment)
  end

  it "renders the edit cuhk_equipment form" do
    render

    assert_select "form[action=?][method=?]", cuhk_equipment_path(cuhk_equipment), "post" do

      assert_select "input[name=?]", "cuhk_equipment[name]"

      assert_select "textarea[name=?]", "cuhk_equipment[description]"
    end
  end
end
