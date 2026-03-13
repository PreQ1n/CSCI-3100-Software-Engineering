Feature: send email to users as a confirmation record of their booking

  As a booking service
  I want to send booking confirmation and cancellation emails via the email API
  So that users receive clear records of their bookings


Background: bookings records have been added to database

  Given the following venue_records exist:
  | created_at | date       | is_absence | time  | updated_at       | user_id | venue_id |
  | 01-03-2026 | 08-03-2026 | false      | 11:00 | 01-03-2026 11:00 | 1       | 1        |
  | 02-03-2026 | 09-03-2026 | true       | 12:00 | 08-03-2026 11:00 | 1       | 2        |

  And the following equipment_records exist:
  | created_at | date       | equipment_id | is_absence | time  | updated_at       | user_id |
  | 02-03-2026 | 08-03-2026 | 1            | false      | 11:00 | 02-03-2026 11:00 | 2       |
  | 03-03-2026 | 09-03-2026 | 2            | true       | 11:00 | 08-03-2026 11:00 | 2       |

Scenario: send confirmation email
  Given the user is on the confirmation page
  And the user sees their equipment records
  When the user presses "Confirm"
  Then the system sends a booking confirmation email to the user
  And the email should include the booking date, time, venue and equipment details
  And the user should be on the home page

Scenario: send cancellation email
  Given the user is on the cancellation page
  And the user sees their equipment records
  When the user presses "Confirm"
  Then the system sends a booking cancellation email to the user
  And the email should include the booking date, time, venue and equipment details
  And the email should state the booking is cancelled
  And the user should be on the home page

Scenario: API sends booking confirmation email
  Given a confirmed booking exists for user "user@example.com"
  When the booking service calls the email API to send a "confirmation" email for that booking
  Then the system enqueues a confirmation email to "user@example.com"
  And the email subject should contain "Booking confirmation"
  And the email body should include the booking id, date, time, venue and equipment details

Scenario: API sends booking cancellation email
  Given a cancelled booking exists for user "user@example.com"
  When the booking service calls the email API to send a "cancellation" email for that booking
  Then the system enqueues a cancellation email to "user@example.com"
  And the email subject should contain "Booking cancellation"
  And the email body should include the booking id, date, time, venue and equipment details