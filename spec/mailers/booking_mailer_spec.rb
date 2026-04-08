require "rails_helper"

RSpec.describe BookingMailer, type: :mailer do
  let(:user)         { User.create!(email: "user@example.com", password: "password123", password_confirmation: "password123") }
  let(:venue)        { Venue.create!(name: "Hall A", building: "Block B") }
  let(:venue_record) { VenueRecord.create!(user: user, venue: venue, date: Date.today, time: "10:00", is_absence: false) }

  let(:equipment)        { Equipment.create!(name: "Projector", quantity: 5) }
  let(:equipment_record) { EquipmentRecord.create!(user: user, equipment: equipment, date: Date.today, time: "10:00", is_absence: false) }

  # venue_booking_confirmed function
  describe "#venue_booking_confirmed" do
    let(:mail) { BookingMailer.venue_booking_confirmed(user, venue_record) }

    it "sends to the correct recipient" do
      expect(mail.to).to include(user.email)
    end

    it "has correct subject" do
      expect(mail.subject).to eq("Booking Confirmation")
    end

    it "includes venue name in body" do
      expect(mail.html_part.body.decoded).to include(venue.name)
    end

    it "includes booking date in body" do
      expect(mail.html_part.body.decoded).to include(venue_record.date.to_s)
    end

    it "includes booking time in body" do
      expect(mail.html_part.body.decoded).to include(venue_record.time.strftime("%H:%M"))
    end
  end

  # venue_booking_cancelled function
  describe "#venue_booking_cancelled" do
    let(:mail) { BookingMailer.venue_booking_cancelled(user, venue_record) }

    it "sends to the correct recipient" do
      expect(mail.to).to include(user.email)
    end

    it "has correct subject" do
      expect(mail.subject).to eq("Booking Cancellation")
    end

    it "includes venue name in body" do
      expect(mail.html_part.body.decoded).to include(venue.name)
    end
  end

  # equipment_booking_confirmed function
  describe "#equipment_booking_confirmed" do
    let(:mail) { BookingMailer.equipment_booking_confirmed(user, equipment_record) }

    it "sends to the correct recipient" do
      expect(mail.to).to include(user.email)
    end

    it "has correct subject" do
      expect(mail.subject).to eq("Booking Confirmation")
    end

    it "includes equipment name in body" do
      expect(mail.html_part.body.decoded).to include(equipment.name)
    end
  end

  # equipment_booking_cancelled function
  describe "#equipment_booking_cancelled" do
    let(:mail) { BookingMailer.equipment_booking_cancelled(user, equipment_record) }

    it "sends to the correct recipient" do
      expect(mail.to).to include(user.email)
    end

    it "has correct subject" do
      expect(mail.subject).to eq("Booking Cancellation")
    end

    it "includes equipment name in body" do
      expect(mail.html_part.body.decoded).to include(equipment.name)
    end
  end
end
