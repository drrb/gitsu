Feature: Clear user
    As a user 
    I want to clear my Git configured user
    So that I can make sure others don't commit code as me

    Scenario: Clear user in specified scope
        Given user "John Galt <jgalt@example.com>" is selected in "local" scope
        When I type "git su --clear --local"
        Then no user should be selected in "local" scope

    Scenario: Clear user in multiple specified scopes
        Given user "John Galt <jgalt@example.com>" is selected in "local" scope
        And user "John Galt <jgalt@example.com>" is selected in "global" scope
        When I type "git su --clear --local --global"
        Then no user should be selected in "local" scope
        And no user should be selected in "global" scope

    Scenario: Clear all users
        Given user "Joe Local <jlocal@example.com>" is selected in "local" scope
        And user "Joe Global <jglobal@example.com>" is selected in "global" scope
        And user "Joe System <jsystem@example.com>" is selected in "system" scope
        When I type "git su --clear"
        Then no user should be selected in "local" scope
        And no user should be selected in "global" scope
        And no user should be selected in "system" scope
