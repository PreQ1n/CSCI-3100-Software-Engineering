require 'rails_helper'

RSpec.describe "equipment/show", type: :view do
  let(:user) { User.create!(email: "user@example.com", password: "password123", password_confirmation: "password123") }

  before(:each) do
    assign(:equipment, Equipment.create!(name: "Projector", quantity: 5))
  end

  it "renders attributes in <p>" do
    render
  end
end
