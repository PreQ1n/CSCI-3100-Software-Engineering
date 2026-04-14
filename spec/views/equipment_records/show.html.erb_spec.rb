require 'rails_helper'

RSpec.describe "equipment_records/show", type: :view do
  let(:user) { User.create!(email: "user@example.com", password: "password123", password_confirmation: "password123") }
  let(:equipment) { Equipment.create!(name: "Projector", quantity: 5) }

  before(:each) do
    assign(:equipment_record, EquipmentRecord.create!(user: user, equipment: equipment, date: Date.today, time: "10:00", is_absence: false, borrow_date: Date.today, expected_return_date: Date.today + 3))
  end

  it "renders attributes in <p>" do
    render
  end
end
