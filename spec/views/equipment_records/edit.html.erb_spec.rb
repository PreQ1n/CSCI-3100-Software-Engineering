require 'rails_helper'

RSpec.describe "equipment_records/edit", type: :view do
  let(:user) { User.create!(email: "user@example.com", password: "password123", password_confirmation: "password123") }
  let(:equipment) { Equipment.create!(name: "Projector", quantity: 5) }
  let(:equipment_record) {
    EquipmentRecord.create!(user: user, equipment: equipment, date: Date.today, time: "10:00", is_absence: false, borrow_date: Date.today, expected_return_date: Date.today + 3)
  }

  before(:each) do
    assign(:equipment_record, equipment_record)
  end

  it "renders the edit equipment_record form" do
    render

    assert_select "form[action=?][method=?]", equipment_record_path(equipment_record), "post" do
    end
  end
end
