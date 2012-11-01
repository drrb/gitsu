Feature: Print the current user 
    As a user
    I want to see who is currently logged in 
    So that I know if I need to switch users 

    Scenario: User is selected
        Given user "John Galt <jg@example.com>" is selected
        When I request "" 
        Then I should see "Current user: John Galt <jg@example.com>"

    Scenario: No user is selected
        Given no user is selected
        When I request ""
        Then I should see "Current user: (none)"
