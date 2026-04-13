Feature: using Google Maps API to generate interactive maps of the venues selected

    @javascript
    Scenario: user sees maps of corresponding venues on the booking page
        Given I am logged in as "student@gmail.com" with password "111"
        And a venue named "New Asia College" exists with lat: 22.42101 and lng: 114.20922
        And I am on the venue booking page of the venue
        Then I should see a map available
        And the map is centered on the coordinates of the venue