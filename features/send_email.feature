Feature: send email to users as a confirmation record of their booking

  As a booking service
  I want to send booking confirmation and cancellation emails via the email API
  So that users receive clear records of their bookings

Background:
  Given the following users exist:
    | id | email             |
    | 1  | user@example.com  |

  And the following venues exist:
    | id | name   | building |
    | 1  | Hall A | Block 1  |

  And the following equipment exist:
    | id | name      | quantity |
    | 1  | Projector | 5        |

  And the following venue_records exist:
    | date       | is_absence | time  | user_id | venue_id |
    | 08-03-2026 | false      | 11:00 | 1       | 1        |

  And the following equipment_records exist:
    | date       | equipment_id | is_absence | time  | user_id |
    | 08-03-2026 | 1            | false      | 11:00 | 1       |

# Confirmation Emails

Scenario: user confirms venue booking and receives confirmation email
  Given a user is logged in as "user@example.com"
  And the user is on the venue booking confirmation page
  When the user presses "Confirm"
  Then the venue_record is_absence should be false
  And the user "user@example.com" should receive a confirmation email
  And the email subject should contain "Booking Confirmation"
  And the email body should include the venue name and booking date and time
  And the user should be redirected to the home page

Scenario: user confirms equipment booking and receives confirmation email
  Given a user is logged in as "user@example.com"
  And the user is on the equipment booking confirmation page
  When the user presses "Confirm"
  Then the equipment_record is_absence should be false
  And the user "user@example.com" should receive a confirmation email
  And the email subject should contain "Booking Confirmation"
  And the email body should include the equipment name and booking date and time
  And the user should be redirected to the home page

# Cancellation Emails

Scenario: staff marks venue booking as absent and cancellation email is sent
  Given a staff member is logged in
  And the staff is on the venue absence management page
  When the staff marks the venue booking as absent and presses "Confirm"
  Then the venue_record is_absence should be true
  And the user "user@example.com" should receive a cancellation email
  And the email subject should contain "Booking Cancellation"
  And the email body should include the venue name and booking date and time
  And the staff should be redirected to the home page

Scenario: staff marks equipment booking as absent and cancellation email is sent
  Given a staff member is logged in
  And the staff is on the equipment absence management page
  When the staff marks the equipment booking as absent and presses "Confirm"
  Then the equipment_record is_absence should be true
  And the user "user@example.com" should receive a cancellation email
  And the email subject should contain "Booking Cancellation"
  And the email body should include the equipment name and booking date and time
  And the staff should be redirected to the home page