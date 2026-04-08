Feature: Analytics Dashboard

  As an administrator
  I want to view the analytics dashboard
  So that I can monitor resource usage and user behavior

Background:
  Given the following venues exist:
    | id | name        | 
    | 1  | LSB LT1     |
    | 2  | ERB 407     | 
    | 3  | SC L3       | 

  And the following equipment exist:
    | id | name          | quantity |
    | 1  | Projector     | 5        |
    | 2  | Laptop        | 10       |
    | 3  | Microscope    | 2        |

  And the following users exist:
    | id | email                | faculty       | college      | major         |
    | 1  | user1@example.com    | Engineering   | Chung Chi    | Computer Sci  |
    | 2  | user2@example.com    | Business      | Shaw         | Marketing     |
    | 3  | user3@example.com    | Engineering   | United       | Electrical    |
    | 4  | user4@example.com    | Social Science| New Asia     | Sociology     |
    | 5  | user5@example.com    | Business      | Chung Chi    | Finance       |
    | 6  | user6@example.com    | Engineering   | Shaw         | Computer Sci  |
    | 7  | user7@example.com    | Science       | Chung Chi    | Physics       |
    | 8  | user8@example.com    | Science       | New Asia     | Chemistry     |
    | 9  | user9@example.com    | Business      | United       | Marketing     |
    | 10 | user10@example.com   | Engineering   | Shaw         | Computer Sci  |
    | 11 | user11@example.com   | Business      | Chung Chi    | Finance       |
    | 12 | user12@example.com   | Engineering   | Chung Chi    | Electrical    |

  And the following venue_records exist:
    | user_id | venue_id | date       | time  | is_absence |
    | 1       | 1        | 2026-03-01 | 10:00 | false      |
    | 2       | 1        | 2026-03-01 | 14:00 | false      |
    | 3       | 1        | 2026-03-01 | 15:00 | false      |
    | 4       | 2        | 2026-03-02 | 09:00 | false      |
    | 5       | 2        | 2026-03-02 | 11:00 | false      |
    | 1       | 3        | 2026-03-02 | 13:00 | false      |
    | 6       | 1        | 2026-03-02 | 16:00 | false      |
    | 7       | 1        | 2026-03-02 | 17:00 | false      |
    | 2       | 1        | 2026-03-03 | 10:00 | false      |
    | 3       | 2        | 2026-03-03 | 15:00 | false      |
    | 8       | 3        | 2026-03-03 | 09:00 | false      |
    | 9       | 1        | 2026-03-03 | 11:00 | true       |  
    | 10      | 1        | 2026-03-03 | 12:00 | false      |
    | 11      | 2        | 2026-03-04 | 14:00 | false      |
    | 12      | 3        | 2026-03-04 | 10:00 | false      |
    | 1       | 1        | 2026-03-04 | 18:00 | false      |
    | 4       | 2        | 2026-03-04 | 19:00 | false      |
    | 5       | 1        | 2026-03-05 | 09:00 | false      |
    | 6       | 1        | 2026-03-05 | 10:00 | false      |
    | 7       | 1        | 2026-03-05 | 11:00 | true       |   
    | 2       | 2        | 2026-03-05 | 15:00 | false      |

  And the following equipment_records exist:
    | user_id | equipment_id | date       | time  | is_absence | is_returnLate |
    | 1       | 1            | 2026-03-01 | 10:00 | false      | false         |
    | 2       | 1            | 2026-03-01 | 14:00 | false      | true          |  
    | 3       | 2            | 2026-03-01 | 15:00 | false      | false         |
    | 4       | 3            | 2026-03-02 | 09:00 | false      | false         |
    | 5       | 1            | 2026-03-02 | 11:00 | false      | false         |
    | 1       | 2            | 2026-03-02 | 13:00 | false      | false         |
    | 6       | 1            | 2026-03-02 | 16:00 | false      | false         |
    | 7       | 1            | 2026-03-02 | 17:00 | false      | false         |
    | 2       | 2            | 2026-03-03 | 10:00 | false      | false         |
    | 3       | 3            | 2026-03-03 | 15:00 | false      | false         |
    | 8       | 1            | 2026-03-03 | 09:00 | false      | false         |
    | 9       | 2            | 2026-03-03 | 11:00 | true       | false         |  
    | 10      | 1            | 2026-03-03 | 12:00 | false      | false         |
    | 11      | 2            | 2026-03-04 | 14:00 | false      | true          |  
    | 12      | 3            | 2026-03-04 | 10:00 | false      | false         |
    | 1       | 1            | 2026-03-04 | 18:00 | false      | false         |
    | 4       | 2            | 2026-03-04 | 19:00 | false      | false         |
    | 5       | 1            | 2026-03-05 | 09:00 | false      | false         |
    | 6       | 2            | 2026-03-05 | 10:00 | false      | false         |
    | 7       | 1            | 2026-03-05 | 11:00 | true       | false         |  

Scenario: Overall usage rate is correctly displayed (Period: 2026-03-01 to 2026-03-05)
  Given I am logged in as an administrator
  When I visit the analytics dashboard
  Then I should see "Overall Usage Rate"
  And the overall usage rate should be displayed as "11.4%"

Scenario: Weekly peak hours are correctly shown
  Given I am logged in as an administrator
  When I visit the analytics dashboard
  Then I should see a chart labeled "Peak Hours (Weekly)"
  And the hour "10:00" should be among the top 3 peak hours
  And the hour "11:00" should be among the top 3 peak hours
  And the hour "15:00" should be among the top 3 peak hours

Scenario: Popular venues and equipment are correctly ranked
  Given I am logged in as an administrator
  When I visit the analytics dashboard
  Then I should see a list of top venues by booking count
  And "LSB LT1" should be the top venue
  And I should see a list of top equipment by booking count
  And "Projector" should be the top equipment

Scenario: Absence rate is correctly displayed
  Given I am logged in as an administrator
  When I visit the analytics dashboard
  Then I should see "Absence Rate"
  And the Absence rate should be displayed as "9.8%"

Scenario: Faculty booking distribution is shown
  Given I am logged in as an administrator
  When I visit the analytics dashboard
  Then I should see a breakdown by faculty
  And "Engineering" should have the highest booking count
  And the booking count for "Engineering" should be displayed as "10"
  And the booking count for "Business" should be displayed as "8"
  And the booking count for "Science" should be displayed as "4"
  And the booking count for "Social Science" should be displayed as "2"

Scenario: College booking distribution is shown
  Given I am logged in as an administrator
  When I visit the analytics dashboard
  Then I should see a breakdown by college
  And "Chung Chi" should have the highest booking count
  And the booking count for "Chung Chi" should be displayed as "7"
  And the booking count for "Shaw" should be displayed as "6"
  And the booking count for "United" should be displayed as "4"
  And the booking count for "New Asia" should be displayed as "4"

Scenario: Top 5 majors by booking count are shown
  Given I am logged in as an administrator
  When I visit the analytics dashboard
  Then I should see a list of top 5 majors by booking count
  And "Computer Sci" should be the top major
  And the booking count for "Computer Sci" should be at least "3"

Scenario: Late return rate is correctly displayed
  Given I am logged in as an administrator
  When I visit the analytics dashboard
  Then I should see "Late Return Rate"
  And the late return rate should be displayed as "10.0%"