Feature: Clear user
    As a user 
    I want to clear my Git configured user
    So that I can make sure others don't commit code as me

    Scenario: Clear user in specified scope
        Given user "John Galt <jgalt@example.com>" is selected in "local" scope
        When I type "git su --clear --local"
        Then no user should be selected in "local" scope

