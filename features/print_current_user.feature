Feature: Print the current user 
    As a user
    I want to see who is currently logged in 
    So that I know if I need to switch users 

    Scenario: Print the current user
        Given user "John Galt <jg@example.com>" is selected
        When I request the current user 
        Then I should see "Current user: John Galt <jg@example.com>"
