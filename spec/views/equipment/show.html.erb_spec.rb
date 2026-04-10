require 'rails_helper'

RSpec.describe "equipment/show", type: :view do
  before(:each) do
    assign(:equipment, Equipment.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
