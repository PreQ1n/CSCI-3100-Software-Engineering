mail api feature require .env which didn't upload to remote repositary

for running BDD & TDD test for this feature:
bundle exec rspec spec/services/brevo_email_spec.rb
bundle exec cucumber features/send_email.feature

check functionable locally: (Remind on email in line 12)
rail console

#change the email when test on local
User.create!(
email: "your email",
password: "password123",
password_confirmation: "password123"
)

venue = Venue.create!(
name: "LT1",
building: "MMW"
)

venue_record = VenueRecord.create!(
user: user,
venue: venue,
date: Date.today,
time: "10:00",
is_absence: false
)

BrevoEmail.venue_booking_confirmed(user, venue_record)
