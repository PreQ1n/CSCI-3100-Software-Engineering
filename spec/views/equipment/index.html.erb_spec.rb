require 'rails_helper'

RSpec.describe "equipment/index", type: :view do
  let!(:equipment1) { Equipment.create!(name: "Projector", quantity: 5) }
  let!(:equipment2) { Equipment.create!(name: "Microphone", quantity: 3) }

  before do
    assign(:equipment, [ equipment1, equipment2 ])
  end

  it "renders a list of equipment" do
    render
    expect(rendered).to include("Projector")
    expect(rendered).to include("Microphone")
  end
end
