require "rails_helper"

RSpec.describe BrevoEmail, type: :service do
  let(:user) { User.create!(email: "user@example.com", password: "password123", password_confirmation: "password123") }
  let(:venue) { Venue.create!(name: "Hall A", building: "Block B") }
  let(:venue_record) { VenueRecord.create!(user: user, venue: venue, date: Date.today, time: "10:00", is_absence: false) }
  let(:equipment) { Equipment.create!(name: "Projector", quantity: 5) }
  let(:equipment_record) { EquipmentRecord.create!(user: user, equipment: equipment, date: Date.today, time: "10:00", is_absence: false) }

  # Stub Brevo API — no real emails sent
  before do
    BrevoEmail.deliveries = []
    allow_any_instance_of(SibApiV3Sdk::TransactionalEmailsApi)
      .to receive(:send_transac_email)
  end

  # venue_booking_confirmed
  describe ".venue_booking_confirmed" do
    before { BrevoEmail.venue_booking_confirmed(user, venue_record) }
    let(:mail) { BrevoEmail.deliveries.last }

    it "sends to the correct recipient" do
      expect(mail[:to]).to eq(user.email)
    end

    it "has correct subject" do
      expect(mail[:subject]).to eq("Booking Confirmation")
    end

    it "includes venue name in body" do
      expect(mail[:html]).to include(venue.name)
    end

    it "includes booking date in body" do
      expect(mail[:html]).to include(venue_record.date.to_s)
    end

    it "includes booking time in body" do
      expect(mail[:html]).to include(venue_record.time.strftime("%H:%M"))
    end
  end

  # venue_booking_cancelled
  describe ".venue_booking_cancelled" do
    before { BrevoEmail.venue_booking_cancelled(user, venue_record) }
    let(:mail) { BrevoEmail.deliveries.last }

    it "sends to the correct recipient" do
      expect(mail[:to]).to eq(user.email)
    end

    it "has correct subject" do
      expect(mail[:subject]).to eq("Booking Cancellation")
    end

    it "includes venue name in body" do
      expect(mail[:html]).to include(venue.name)
    end
  end

  # equipment_booking_confirmed
  describe ".equipment_booking_confirmed" do
    before { BrevoEmail.equipment_booking_confirmed(user, equipment_record) }
    let(:mail) { BrevoEmail.deliveries.last }

    it "sends to the correct recipient" do
      expect(mail[:to]).to eq(user.email)
    end

    it "has correct subject" do
      expect(mail[:subject]).to eq("Booking Confirmation")
    end

    it "includes equipment name in body" do
      expect(mail[:html]).to include(equipment.name)
    end
  end

  # equipment_booking_cancelled
  describe ".equipment_booking_cancelled" do
    before { BrevoEmail.equipment_booking_cancelled(user, equipment_record) }
    let(:mail) { BrevoEmail.deliveries.last }

    it "sends to the correct recipient" do
      expect(mail[:to]).to eq(user.email)
    end

    it "has correct subject" do
      expect(mail[:subject]).to eq("Booking Cancellation")
    end

    it "includes equipment name in body" do
      expect(mail[:html]).to include(equipment.name)
    end
  end
end
