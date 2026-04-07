require 'rails_helper'

RSpec.describe "cuhk_equipments/index", type: :view do
  before(:each) do
    assign(:cuhk_equipments, [
      CuhkEquipment.create!(
        name: "Name",
        description: "MyText"
      ),
      CuhkEquipment.create!(
        name: "Name",
        description: "MyText"
      )
    ])
  end

  it "renders a list of cuhk_equipments" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
