Feature: using Google Maps API to generate interactive maps of the venues selected and can to use them to create new venues

    Background: booking records have been added to database

        Given the following venues exists:
        | name                    | venue_id   | latitude | longitude |
        | New Asia College        | 1          | 22.42101 | 114.20922 |
        | Lady Shaw Building      | 2          | 22.41901 | 114.20688 |
        | Lee Shau Kee Building   | 3          | 22.41974 | 114.20395 |
        | Tsang Shiu Tim Building | 4          | 22.42052 | 114.20452 |

    @javascript
    Scenario Outline: user sees maps of corresponding venues on the booking page
        Given I am logged in as "student@gmail.com" with password "111"
        And I am on the venue booking page of "<venue_name>"
        Then I should see a map available
        And the map is centered on the coordinates of "<venue_name>"

        Examples:
        |venue_name|
        |New Asia College|
        |Lady Shaw Building|
        |Lee Shau Kee Building|
        |Tsang Shiu Tim Building|

    @javascript
    Scenario Outline: on the create venue page, admin inputs venue names and maps of corresponding locations are shown
        Given I am logged in as "admin@example.com" with password "password123"
        And I am on the create new venues page
        Then I should see a map available
        And the map is centered on the default coordinates
        Then I search for "<search_term>" in the name field
        Then the map is centered on lat: <lat> long: <long>

        Examples:
        |search_term|lat|long|
        |cuhk medical centre|22.4136093|114.2113817|
        |new asia|22.420989|114.2089572|
        |chung chi|22.4159812|114.2070044|
