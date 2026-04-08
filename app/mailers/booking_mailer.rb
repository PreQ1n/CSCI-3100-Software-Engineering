class BookingMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.venue_booking_confirmed.subject
  #
  def venue_booking_confirmed(user, venue_record)
    @user         = user
    @venue_record = venue_record
    @venue        = venue_record.venue
    mail(to: @user.email, subject: "Booking Confirmation")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.equipment_booking_confirmed.subject
  #
  def equipment_booking_confirmed(user, equipment_record)
    @user             = user
    @equipment_record = equipment_record
    @equipment        = equipment_record.equipment
    mail(to: @user.email, subject: "Booking Confirmation")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.venue_booking_cancelled.subject
  #
  def venue_booking_cancelled(user, venue_record)
    @user         = user
    @venue_record = venue_record
    @venue        = venue_record.venue
    mail(to: @user.email, subject: "Booking Cancellation")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.equipment_booking_cancelled.subject
  #
  def equipment_booking_cancelled(user, equipment_record)
    @user             = user
    @equipment_record = equipment_record
    @equipment        = equipment_record.equipment
    mail(to: @user.email, subject: "Booking Cancellation")
  end
end
