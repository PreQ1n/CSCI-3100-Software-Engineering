require "rails_helper"

RSpec.describe VenueRecordsController, type: :routing do
   describe "routing" do
    it "routes to #index" do
      expect(get: "/venue_records").to route_to("venue_records#index")
    end

    it "routes to #new" do
      expect(get: "/venue_records/new").to route_to("venue_records#new")
    end

    it "routes to #create" do
      expect(post: "/venue_records").to route_to("venue_records#create")
    end

    it "routes to booked_slots" do
      expect(get: "/venue_records/booked_slots").to route_to("venue_records#booked_slots")
    end
  end
end
