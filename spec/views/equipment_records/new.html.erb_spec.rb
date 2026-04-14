require 'rails_helper'

RSpec.describe "equipment_records/new", type: :view do
  let(:user) { User.create!(email: "user@example.com", password: "password123", password_confirmation: "password123") }
  let!(:equipment) { Equipment.create!(name: "Projector", quantity: 5) }

  before(:each) do
    assign(:equipment_record, EquipmentRecord.new(equipment: equipment))
  end

  it "renders new equipment_record form" do
    render

    assert_select "form[action=?][method=?]", equipment_records_path, "post" do
    end
  end
end
