require "sib-api-v3-sdk"
require "ostruct"

class BrevoEmail
  cattr_accessor :deliveries
  self.deliveries = []
  SENDER = { email: "csci31002526t2project@gmail.com", name: "Group 11 - Booking Platform" }.freeze

  # helper
  def self.render(template_name, locals = {})
    path = Rails.root.join("app/views/booking_mailer/#{template_name}.html.erb")
    erb  = ERB.new(File.read(path))
    binding_obj = Object.new
    locals.each do |key, value|
      binding_obj.define_singleton_method(key) { value }
    end
    erb.result(binding_obj.instance_eval { binding })
  end

  def self.send_email(to:, subject:, html:)
    SibApiV3Sdk.configure { |c| c.api_key["api-key"] = ENV["BREVO_API"] }
    api = SibApiV3Sdk::TransactionalEmailsApi.new

    email = SibApiV3Sdk::SendSmtpEmail.new({
      "sender"      => { "email" => SENDER[:email], "name" => SENDER[:name] },
      "to"          => [ { "email" => to } ],
      "subject"     => subject,
      "htmlContent" => html
    })

    response = api.send_transac_email(email)
    self.deliveries << { to: to, subject: subject, html: html }
    response
  end

  # public methods
  def self.venue_booking_confirmed(user, venue_record)
    html = render("venue_booking_confirmed", user: user, venue_record: venue_record)
    send_email(to: user.email, subject: "Booking Confirmation", html: html)
  end

  def self.equipment_booking_confirmed(user, equipment_record)
    html = render("equipment_booking_confirmed", user: user, equipment_record: equipment_record)
    send_email(to: user.email, subject: "Booking Confirmation", html: html)
  end

  def self.venue_booking_cancelled(user, venue_record)
    html = render("venue_booking_cancelled", user: user, venue_record: venue_record)
    send_email(to: user.email, subject: "Booking Cancellation", html: html)
  end

  def self.equipment_booking_cancelled(user, equipment_record)
    html = render("equipment_booking_cancelled", user: user, equipment_record: equipment_record)
    send_email(to: user.email, subject: "Booking Cancellation", html: html)
  end
end
