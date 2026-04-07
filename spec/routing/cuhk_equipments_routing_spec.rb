require "rails_helper"

RSpec.describe CuhkEquipmentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/cuhk_equipments").to route_to("cuhk_equipments#index")
    end

    it "routes to #new" do
      expect(get: "/cuhk_equipments/new").to route_to("cuhk_equipments#new")
    end

    it "routes to #show" do
      expect(get: "/cuhk_equipments/1").to route_to("cuhk_equipments#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/cuhk_equipments/1/edit").to route_to("cuhk_equipments#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/cuhk_equipments").to route_to("cuhk_equipments#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/cuhk_equipments/1").to route_to("cuhk_equipments#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/cuhk_equipments/1").to route_to("cuhk_equipments#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/cuhk_equipments/1").to route_to("cuhk_equipments#destroy", id: "1")
    end
  end
end
