@javascript
Feature: Search Venues
  As a user of the CUHK Venue Booking System
  I want to search for venues by specific columns
  So that I can quickly find the location I need

  Background:
    Given the following venues exist:
      | name            | building | description  |
      | ABC             | POP      | Testing 5    |
      | Teacher 1       | YOU      | Testing 4    |
      | Testing 1       | CYT      | Testing 1    |

  Scenario: Search for a specific venue
    Given I am on the venues page
    When I search for "A"
    Then I should see "ABC"
    And I should see "Teacher 1"
    And I should not see "Testing 1"

  Scenario: Clear the search results
    Given I am on the venues page
    When I search for "A"
    And I follow "Clear"
    Then I should see "Teacher 1"
    And I should see "Testing 1"