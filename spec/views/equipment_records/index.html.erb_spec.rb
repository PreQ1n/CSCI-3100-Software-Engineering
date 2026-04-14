require 'rails_helper'

RSpec.describe "equipment_records/index", type: :view do
  let(:user) { User.create!(email: "user@example.com", password: "password123", password_confirmation: "password123") }
  let(:equipment) { Equipment.create!(name: "Projector", quantity: 5) }

  before(:each) do
    assign(:equipment_records, [
      EquipmentRecord.create!(user: user, equipment: equipment, date: Date.today, time: "10:00", is_absence: false, borrow_date: Date.today, expected_return_date: Date.today + 3),
      EquipmentRecord.create!(user: user, equipment: equipment, date: Date.today, time: "11:00", is_absence: false, borrow_date: Date.today+4, expected_return_date: Date.today + 7)
    ])
  end

  it "renders a list of equipment_records" do
    render
    expect(rendered).to include("10:00")
    expect(rendered).to include("11:00")
  end
end
