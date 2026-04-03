require "rails_helper"

RSpec.describe BookingMailer, type: :mailer do
  describe "venue_booking_confirmed" do
    let(:mail) { BookingMailer.venue_booking_confirmed }

    it "renders the headers" do
      expect(mail.subject).to eq("Venue booking confirmed")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "equipment_booking_confirmed" do
    let(:mail) { BookingMailer.equipment_booking_confirmed }

    it "renders the headers" do
      expect(mail.subject).to eq("Equipment booking confirmed")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "venue_booking_cancelled" do
    let(:mail) { BookingMailer.venue_booking_cancelled }

    it "renders the headers" do
      expect(mail.subject).to eq("Venue booking cancelled")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "equipment_booking_cancelled" do
    let(:mail) { BookingMailer.equipment_booking_cancelled }

    it "renders the headers" do
      expect(mail.subject).to eq("Equipment booking cancelled")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
