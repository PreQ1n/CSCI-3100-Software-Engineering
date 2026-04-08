require "rails_helper"

RSpec.describe EquipmentRecordsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/equipment_records").to route_to("equipment_records#index")
    end

    it "routes to #new" do
      expect(get: "/equipment_records/new").to route_to("equipment_records#new")
    end

    it "routes to #show" do
      expect(get: "/equipment_records/1").to route_to("equipment_records#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/equipment_records/1/edit").to route_to("equipment_records#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/equipment_records").to route_to("equipment_records#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/equipment_records/1").to route_to("equipment_records#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/equipment_records/1").to route_to("equipment_records#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/equipment_records/1").to route_to("equipment_records#destroy", id: "1")
    end
  end
end
