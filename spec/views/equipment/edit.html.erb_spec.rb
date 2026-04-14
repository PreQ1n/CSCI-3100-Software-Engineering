require 'rails_helper'

RSpec.describe "equipment/edit", type: :view do
  let(:user) { User.create!(email: "user@example.com", password: "password123", password_confirmation: "password123") }
  let(:equipment) { Equipment.create!(name: "Projector", quantity: 5) }

  before(:each) do
    assign(:equipment, equipment)
  end

  it "renders the edit equipment form" do
    render
    expect(rendered).to include("form")
  end
end
