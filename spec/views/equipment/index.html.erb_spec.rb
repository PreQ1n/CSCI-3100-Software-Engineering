require 'rails_helper'

RSpec.describe "equipment/index", type: :view do
  before(:each) do
    assign(:equipment, [
      Equipment.create!(),
      Equipment.create!()
    ])
  end

  it "renders a list of equipment" do
    render
    cell_selector = 'div>p'
  end
end
