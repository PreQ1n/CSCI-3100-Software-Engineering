require 'rails_helper'

RSpec.describe "equipment/edit", type: :view do
  let(:equipment) {
    Equipment.create!()
  }

  before(:each) do
    assign(:equipment, equipment)
  end

  it "renders the edit equipment form" do
    render

    assert_select "form[action=?][method=?]", equipment_path(equipment), "post" do
    end
  end
end
