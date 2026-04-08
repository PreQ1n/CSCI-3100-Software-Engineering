# Preview all emails at http://localhost:3000/rails/mailers/booking_mailer_mailer
class BookingMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/booking_mailer_mailer/venue_booking_confirmed
  def venue_booking_confirmed
    BookingMailer.venue_booking_confirmed
  end

  # Preview this email at http://localhost:3000/rails/mailers/booking_mailer_mailer/equipment_booking_confirmed
  def equipment_booking_confirmed
    BookingMailer.equipment_booking_confirmed
  end

  # Preview this email at http://localhost:3000/rails/mailers/booking_mailer_mailer/venue_booking_cancelled
  def venue_booking_cancelled
    BookingMailer.venue_booking_cancelled
  end

  # Preview this email at http://localhost:3000/rails/mailers/booking_mailer_mailer/equipment_booking_cancelled
  def equipment_booking_cancelled
    BookingMailer.equipment_booking_cancelled
  end

end
