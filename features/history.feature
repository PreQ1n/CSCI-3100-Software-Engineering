Feature: History Page

  As a logged-in user
  I want to view my booking history
  So that I can see my past venue and equipment bookings

Background:
  Given the following history venues exist:
    | id | name        |
    | 1  | LSB LT1     |
    | 2  | ERB 407     |

  And the following history equipment exist:
    | id | name          | quantity |
    | 1  | Projector     | 5        |
    | 2  | Laptop        | 10       |

  And the following history users exist:
    | id | email             | faculty     | college   | major        |
    | 1  | user1@example.com | Engineering | Chung Chi | Computer Sci |

  And the following history venue_records exist:
    | user_id | venue_id | date       | time  | is_absence |
    | 1       | 1        | 2026-03-01 | 10:00 | false      |
    | 1       | 2        | 2026-03-02 | 14:00 | true       |

  And the following history equipment_records exist:
    | user_id | equipment_id | date       | time  | is_absence | is_returnLate |
    | 1       | 1            | 2026-03-01 | 10:00 | false      | false         |
    | 1       | 2            | 2026-03-02 | 14:00 | false      | true          |

  And I am logged in as user "user1@example.com"

Scenario: View venue bookings by default
  When I visit the history page
  Then I should see the "Venue Bookings" button
  And I should see the "Equipment Bookings" button
  And I should see a table with venue records
  And the table should have columns "Name", "Date", "Is Absence", "Time"
  And I should see "LSB LT1" in the venue table
  And I should see "ERB 407" in the venue table
  And the venue record for "LSB LT1" should show "Is Absence" as "No"
  And the venue record for "ERB 407" should show "Is Absence" as "Yes"

Scenario: Switch to equipment bookings
  When I visit the history page
  And I click the history button "Equipment Bookings"
  Then I should see a table with equipment records
  And the table should have columns "Name", "Date", "Is Absence", "Is Return Late", "Time"
  And I should see "Projector" in the equipment table
  And I should see "Laptop" in the equipment table
  And the equipment record for "Projector" should show "Is Return Late" as "No"
  And the equipment record for "Laptop" should show "Is Return Late" as "Yes"

Scenario: Switch back to venue bookings
  When I visit the history page
  And I click the history button "Equipment Bookings"
  And I click the history button "Venue Bookings"
  Then I should see a table with venue records
  And the table should have columns "Name", "Date", "Is Absence", "Time"
  And I should see "LSB LT1" in the venue table

Scenario: No records found for user
  Given I am logged in as a user with no bookings
  When I visit the history page
  Then I should see the history message "No records found."