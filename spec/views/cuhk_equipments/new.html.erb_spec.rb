require 'rails_helper'

RSpec.describe "cuhk_equipments/new", type: :view do
  before(:each) do
    assign(:cuhk_equipment, CuhkEquipment.new(
      name: "MyString",
      description: "MyText"
    ))
  end

  it "renders new cuhk_equipment form" do
    render

    assert_select "form[action=?][method=?]", cuhk_equipments_path, "post" do

      assert_select "input[name=?]", "cuhk_equipment[name]"

      assert_select "textarea[name=?]", "cuhk_equipment[description]"
    end
  end
end
