Feature: Booking record management

  As a registered user
  I want to book a venue by selecting a date and timeslot
  So that a booking record is created for me in the database

  Background:
    Given the following users exist:
      | email             |
      | user1@example.com |
      | user2@example.com |

    And the following venues exist:
      | name    | building |
      | MMW LT1 | MMW      |

    And the following equipment exist:
      | name      | quantity |
      | Projector | 5        |

  # Happy path
	# -----
  Scenario: User successfully books an available venue timeslot
    Given a user is logged in as "user1@example.com"
    And the user is on the venues index page
    When the user clicks "Book" for venue "MMW LT1" in building "MMW"
    And the user selects date "2026-04-11"
    And the user selects timeslot "16:00"
    And the user clicks "Book"
    Then a venue record exists for "user1@example.com" at "MMW LT1" on "2026-04-11" at "16:00"

  # Sequential double booking
	# -----
  Scenario: Second user cannot book an already taken timeslot
    Given a venue record exists for "user1@example.com" at "MMW LT1" on "2026-04-11" at "16:00"
    And a user is logged in as "user2@example.com"
    And the user is on the venue booking page for "MMW LT1"
    When the user selects date "2026-04-11"
    Then the timeslot "16:00" is shown as unavailable
    And the user cannot submit a booking for timeslot "16:00"

  # Concurrent double booking
	# -----
  @concurrent
  Scenario: Only one booking is accepted when two users submit simultaneously
    Given "user1@example.com" and "user2@example.com" both attempt to book "MMW LT1" on "2026-04-11" at "16:00" at the same time
    Then exactly one venue record exists for "MMW LT1" on "2026-04-11" at "16:00"
    And one user receives a booking confirmation
    And the other user receives an error "This slot was just taken. Please pick another time."

  # Database constraint
	# -----
  Scenario: Database rejects a duplicate booking record directly
    Given a venue record exists for "user1@example.com" at "MMW LT1" on "2026-04-11" at "16:00"
    When "user2@example.com" attempts to create a venue record for "MMW LT1" on "2026-04-11" at "16:00"
    Then the booking is rejected
    And the error message is "has already been taken"
    And only one venue record exists for "MMW LT1" on "2026-04-11" at "16:00"