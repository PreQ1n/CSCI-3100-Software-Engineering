@javascript
Feature: Equipment Search
  As a student or staff
  I want to search for equipment by name
  So I can check what is available for booking

  Background: equipment in the database
    Given the following equipment exists:
      | name             | description                    |
      | Badminton	       |Good|	
      | Camera	         |Bad|	
      | Computer	       |Fast and New|

  Scenario: Live search for a specific item
    Given I am on the equipment page
    When I search for "C"
    Then I should see "Camera"
    And I should see "Computer"
    And I should not see "Badminton"


  Scenario: Searching for a non-existent item
    Given I am on the equipment page
    When I search for "Spaceship"
    Then I should see "No equipment found matching"
    And I should see "Spaceship"

  Scenario: Clearing the search results
    Given I am on the equipment page
    When I search for "Badminton"
    And I follow "Clear"
    Then I should see "Camera"
    And I should see "Computer"