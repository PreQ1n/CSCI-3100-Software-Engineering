Feature: Account
    As a user,
    I want a account menu,
    So that I can access three functions, namely Confirmation, Calendar and History

    Background:
    Given I am logged in as a user

    Scenario: Account menu displays all option
    When My mouse on the account button
    Then a dropdown menu show
    And there are three option to choose:
        | Confirmation |
        | Calendar     |
        | History      |

Scenario Outline: Navigate to different pages through account menu
    When My mouse on the account button
    When I click on the "<menu_option>" option in the account menu
    Then I should be on the "<page_path>"

    Examples: 
      | menu_option   | page_path          |
      | Confirmation  | confirmation_path  |
      | Calendar      | calendar_path      |
      | History       | history_path       |

    Scenario: New confirmation shows up in confirmation page
    Given I am on the "Confirmation" page
    When I have a new confirmation
    Then it will show up a new confirmation 
    And the confirmation will have a ✅Press to Confirm button

    Scenario: Confirm button removes confirmation from UI 
    Given I am on the "Confirmation" page
    And I have a new confirmation
    When I click the ✅Press to Confirm button
    Then the record will be removed
    And the recored will be update in the database

    Scenario: Calendar page displays monthly view by default
    Given I am on the "Calendar" page 
    Then I should see a monthly calendar view
    And the current month and year should be display at the top
    And the days of the week should also be display

    Scenario: Calendar page will show up the booked-venue record
    Given I am on the "Calendar" page
    And I have the following booked
    | Name | Borrow Date | Return Date |
    | testing_equipment_1 | 2-4-2026 | 4-4-2026 |
    | testing_equipment_2 | 10-4-2026 | 12-4-2026 |
    Then 2 April should show "testing_equipment_1" on that day
    And 10 April should show "testing_equipment_2" on that day

    Scenario: Calendar page will show up the booked-equipment record
    Given I am on the "Calendar" page
    And I have the following booked
    | Name | Date | Time |
    | testing_equipment_1 | 2-4-2026 | 13:00 |
    | testing_equipment_2 | 10-4-2026 | 16:00 |
    Then 2 April should show "testing_equipment_1" and "13:00" on that day
    And 10 April should show "testing_equipment_2" and "16:00" on that day

    

