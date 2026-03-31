Feature: Account
    As a user,
    I want a account menu,
    So that I can access three functions, namely Confirmation, Calendar and History

    Background:
    Given I am logged in as a user

    Scenario: Account menu displays all option
    When My mouse on the "account" button
    Then a dropdown menu show
    And there are three option to choose: 
        | Confirmation |
        | Calendar     |
        | History      |

    Scenario Outline: Navigate to different pages through account menu
    Given My mouse on the "account" button
    When I click on the "<menu_option>" option in the account menu
    Then I should be on the <page_path>

    Examples:
        | menu_option   | page_path          |
        | Confirmation  | confirmation_path  |
        | Calendar      | calendar_path      |
        | History       | history_path       |

    Scenario: Account menu close when mouse move away
    Given My mouse on the "account" button
    And a dropdown menu show
    When my mouse not on the button 
    Then a dropdown menu not show

    Scenario Outline: Each Page formating 
    Given I am on the "<title>" page
    And the title should be "<title>"
    And there is a "back to main page" button
    When I click the "back to main page" button
    Then I am on the "main" page

    Examples:
        | title |
        | Confirmation  | 
        | Calendar      | 
        | History       | 


    Scenario: New confirmation shows up in confirmation page
    Given I am on the "confirmation" page
    When I have a new confirmation
    Then it will show up a new confirmation 
    And the confirmation will have a "Confirm" button

    Scenario: Confirm button removes confirmation from UI 
    Given I am on the "confirmation" page
    And I have a new confirmation
    When I click the "Confirm" button
    Then the record will be removed
    And the recored will be update in the database

    Scenario: Calendar page displays monthly view by default
    Given I am on the "calendar" page 
    Then I should see a monthly calendar view
    And the current month and year should be display at the top
    And the days of the week should also be display

    Scenario: Calendar page will show up the booked-venue record
    Given I am on the "calendar" page
    And I have the the following booked
    | Name | Date | Time |
    | tesing_venue_1 | 2-3-2026 | 13:00 |
    | testing_venue_2 | 10-3-2026 | 16:00 |
    Then 2 March should show "testing_venue_1" and "13:00" on that day
    And 10 March should show "testing_venue_2" and "16:00" on that day

    Scenario: Calendar page will show up the booked-equipment record
    Given I am on the "calendar" page
    And I have the the following booked
    | Name | Date | Time |
    | tesing_equipment_1 | 2-3-2026 | 13:00 |
    | testing_equipment_2 | 10-3-2026 | 16:00 |
    Then 2 March should show "testing_equipment_1" and "13:00" on that day
    And 10 March should show "testing_equipment_2" and "16:00" on that day

    

