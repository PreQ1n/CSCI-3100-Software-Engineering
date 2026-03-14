Feature: Authentication
    As a user
    I want to log in or log out 
    So that I can access my account

    Background:
        Given the following user exists:
        | email             | password | faculty | major | college |
        | student@gmail.com | 111      | Art     | Chinese   | UC      |

    Scenario: Login page
    Given I am not logged in
    When I press the "login" button 
    Then I will navigate to the login page
    And I should see the "Login" header
    
    Scenario: Successfully login
    Given I am on the login page
    When I fill in the "Email" field with "student@gmail.com"
    And I fill in the "Password" field with "111"
    And I click the "Login" button
    Then I should see message "Logged In"
    And I should on the main page
    And I should see a "logout" button

    Scenario: Wrong Email lead to Login failure
    Given I am on the login page
    When I fill in the "Email" field with "stuent@gmail.com"
    And I fill in the "Password" field with "111"
    And I click the "Login" button
    Then I should see message "Invaild Email or Password"

    Scenario: Wrong password lead to Login failure
    Given I am on the login page
    When I fill in the "Email" field with "student@gmail.com"
    And I fill in the "Password" field with "11"
    And I click the "Login" button
    Then I should see message "Invaild Email or Password"

    Scenario: Logout function
    Given I am logged in 
    When I press the "logout" button
    Then I am logged out 

    