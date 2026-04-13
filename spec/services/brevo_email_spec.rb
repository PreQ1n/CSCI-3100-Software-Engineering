require "rails_helper"

RSpec.describe BrevoEmail, type: :service do
  let(:user) { User.create!(email: "user@example.com", password: "password123", password_confirmation: "password123") }
  let(:venue) { Venue.create!(name: "LT1", building: "LSB", latitude: "22.41901", longitude: "114.20688") }
  let(:venue_record) { VenueRecord.create!(user: user, venue: venue, date: Date.today, time: "10:00", is_absence: nil) }
  let(:equipment) { Equipment.create!(name: "Projector", quantity: 5) }
  let(:equipment_record) { EquipmentRecord.create!(user: user, equipment: equipment, date: Date.today, time: "10:00", is_absence: false, borrow_date: Date.today, expected_return_date: Date.today + 3) }

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

  # venue_attendance_confirmed
  describe ".venue_attendance_confirmed" do
    before { BrevoEmail.venue_attendance_confirmed(user, venue_record) }
    let(:mail) { BrevoEmail.deliveries.last }

    it "sends to the correct recipient" do
      expect(mail[:to]).to eq(user.email)
    end

    it "has correct subject" do
      expect(mail[:subject]).to eq("Attendance Confirmation")
    end

    it "includes venue name in body" do
      expect(mail[:html]).to include(venue.name)
    end
  end

  # venue_absence_reminder
  describe ".venue_absence_reminder" do
    before { BrevoEmail.venue_absence_reminder(user, venue_record) }
    let(:mail) { BrevoEmail.deliveries.last }

    it "sends to the correct recipient" do
      expect(mail[:to]).to eq(user.email)
    end

    it "has correct subject" do
      expect(mail[:subject]).to eq("Absence Reminder")
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

  # equipment_attendance_confirmed
  describe ".equipment_attendance_confirmed" do
    before { BrevoEmail.equipment_attendance_confirmed(user, equipment_record) }
    let(:mail) { BrevoEmail.deliveries.last }

    it "sends to the correct recipient" do
      expect(mail[:to]).to eq(user.email)
    end

    it "has correct subject" do
      expect(mail[:subject]).to eq("Attendance Confirmation")
    end

    it "includes equipment name in body" do
      expect(mail[:html]).to include(equipment.name)
    end
  end

  # equipment_absence_reminder
  describe ".equipment_absence_reminder" do
    before { BrevoEmail.equipment_absence_reminder(user, equipment_record) }
    let(:mail) { BrevoEmail.deliveries.last }

    it "sends to the correct recipient" do
      expect(mail[:to]).to eq(user.email)
    end

    it "has correct subject" do
      expect(mail[:subject]).to eq("Absence Reminder")
    end

    it "includes equipment name in body" do
      expect(mail[:html]).to include(equipment.name)
    end
  end
end
