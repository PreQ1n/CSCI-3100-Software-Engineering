Feature: send email to users as a confirmation record of their booking

  As a booking service
  I want to send booking confirmation and cancellation emails via the email API
  So that users receive clear records of their bookings

Background:
  Given the following users exist:
    | email             |
    | user@example.com  |

  And the following venues exist:
    | name   | building |
    | MMW LT1 | MMW      |

  And the following equipment exist:
    | name      | quantity |
    | Projector | 5        |

  And the following venue_records exist:
    | date       | is_absence | time  |
    | 08-03-2026 | false      | 11:00 |

  And the following equipment_records exist:
    | borrow_date | expected_return_date | is_absence | is_returnLate |
    | 08-03-2026  | 09-03-2026           | false      | false         |

# Confirmation Emails

Scenario: user confirms venue booking and receives confirmation email
  Given a user is logged in as "user@example.com"
  And the user is on the venue booking confirmation page
  When the user presses "Confirm"
  Then the venue_record is_absence should be false
  And the user "user@example.com" should receive a confirmation email
  And the email subject should contain "Booking Confirmation"
  And the email body should include the venue name and booking date and time

Scenario: user books equipment and receives booking confirmation email
  When an equipment record is created for "user@example.com" for "Projector" on "2026-03-08" at "11:00"
  Then the user "user@example.com" should receive a confirmation email
  And the email subject should contain "Booking Confirmation"
  And the email body should include the equipment name and borrow and return dates
  And the user should be redirected to the home page

# Attendance Confirmation Emails (sent when user confirms attendance)
Scenario: user confirms attendance for venue booking and receives attendance confirmation email
  When the is_absence value of venue record is updated as false for "user@example.com" at "MMW LT1" on "2026-03-08" at "11:00"
  Then the user "user@example.com" should receive a attendance confirmation email
  And the email subject should contain "Attendance Confirmation"
  And the email body should include the venue name and booking date and time

Scenario: user confirms attendance for equipment booking and receives attendance confirmation email
  When the is_absence value of equipment record is updated as false for "user@example.com" for "Projector" on "2026-03-08" at "11:00"
  Then the user "user@example.com" should receive a attendance confirmation email
  And the email subject should contain "Attendance Confirmation"
  And the email body should include the equipment name and booking date and time

# Absent Emails
Scenario: staff marks venue booking as absent and absence reminder email is sent
  When the is_absence value of venue record is updated as true for "user@example.com" at "MMW LT1" on "2026-03-08" at "11:00"
  Then the user "user@example.com" should receive a reminder email
  And the email subject should contain "Absence Reminder"
  And the email body should include the venue name and booking date and time

Scenario: staff marks equipment booking as absent and absence reminder email is sent
  When the is_absence value of equipment record is updated as true for "user@example.com" for "Projector" on "2026-03-08" at "11:00"
  Then the user "user@example.com" should receive a reminder email
  And the email subject should contain "Absence Reminder"
  And the email body should include the equipment name and borrow and return dates
