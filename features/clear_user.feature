Feature: Clear user
    As a user 
    I want to clear my Git configured user
    So that I can make sure others don't commit code as me

    Scenario: Clear user
        Given user "John Galt <jgalt@example.com>" is selected
        When I type "git su --clear"
        Then no user should be selected

