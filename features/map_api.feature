Feature: using Google Maps API to generate interactive maps of the venues selected

    As a user booking venues
    I want to see maps of the venue I booked on the venue page

    Background: booking records have been added to database

        Given the following venue_records exist:
        | user_id | venue_id | date       | time  | is_absence | 
        | 1       | 1        | 08-03-2026 | 11:00 | false      |   
        | 1       | 2        | 09-03-2026 | 12:00 | true       |
        | 2       | 3        | 10-03-2026 | 14:00 | false      |

        And the following venues exist:
        | name                    | venue_id   | building                | description  | latitude | longitude |
        | New Asia College        | 1          | Leung Hung Kee Building | new asia     | 22.42101 | 114.20922 |
        | Lady Shaw Building      | 2          | LT1                     | lady shaw    | 22.41901 | 114.20688 |
        | Lee Shau Kee Building   | 3          | LT2                     | lee shau kee | 22.41974 | 114.20395 |
        | Tsang Shiu Tim Building | 4          | UCA 104                 | tst          | 22.42052 | 114.20452 |
        
    Scenario: check if maps exist
        Given I am on Venue page
        Then I should see a map of New Asia College at 22.42101, 114.20922
        Then I should see a map of Lady Shaw Building at 22.41901, 114.20688 
        Then I should see a map of New Asia College at 22.41974, 114.20395

    Scenario: create a new venue_record and check if its corresponding map exist
        Given I am on Venue page
        When I press Add New Venue
        And I fill in Name with Tsang Shuy Tim Building
        And I fill in Venue with 4
        And I press Create Venue
        And I press Back to venues
        Then I should see a map of Tsang Shiu Tim Building at 22.42052, 114.20452
